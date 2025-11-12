//
//  LocationService.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import CoreLocation
import MapKit

final class LocationService: NSObject, LocationServiceProtocol {
    
    // MARK: - Properties
    
    /// CLLocationManager is not Sendable, but safe to use within MainActor context
    /// Using nonisolated(unsafe) as we ensure all access happens on MainActor
    nonisolated(unsafe) private let locationManager: CLLocationManager
    private var continuation: CheckedContinuation<String?, Error>?
    /// Array to store multiple permission continuations for concurrent requests
    /// Must be accessed only on MainActor
    @MainActor private var permissionContinuations: [CheckedContinuation<Bool, Never>] = []
    /// Flag to track if permission continuations have been resolved
    @MainActor private var permissionResolved = false
    private let defaultCountryCode: String
    
    // MARK: - Initialization
    
    /// Initializes LocationService
    /// Note: CLLocationManager operations are safe to perform during initialization
    nonisolated init(
        locationManager: CLLocationManager = CLLocationManager(),
        defaultCountryCode: String = AppConstants.Location.defaultCountryCode
    ) {
        self.locationManager = locationManager
        self.defaultCountryCode = defaultCountryCode
        super.init()
        // CLLocationManager delegate setup is safe to do synchronously
        // Using nonisolated(unsafe) allows us to access it here
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }
    
    // MARK: - LocationServiceProtocol Implementation
    
    nonisolated func requestLocationPermission() async -> Bool {
        let status = await MainActor.run { locationManager.authorizationStatus }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            await MainActor.run {
                locationManager.requestWhenInUseAuthorization()
            }
            // Use Task to handle async continuation on MainActor with timeout
            return await Task { @MainActor in
                // Check one more time in case authorization was granted synchronously
                let initialStatus = self.locationManager.authorizationStatus
                if initialStatus == .authorizedWhenInUse || initialStatus == .authorizedAlways {
                    return true
                }
                
                // Check if permission was already resolved by another concurrent request
                if self.permissionResolved {
                    // Another request already resolved it, check current status
                    let currentStatus = self.locationManager.authorizationStatus
                    return currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways
                }
                
                // Create a task for the delegate callback
                let delegateTask = Task { @MainActor in
                    await withCheckedContinuation { continuation in
                        // Add continuation to array synchronously (we're on MainActor)
                        self.permissionContinuations.append(continuation)
                    }
                }
                
                // Create a timeout task that polls
                let timeoutTask = Task { @MainActor in
                    // Poll every 0.1 seconds for up to 2 seconds
                    for _ in 0..<20 {
                        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                        
                        // Check if already resolved by another task
                        if self.permissionResolved {
                            delegateTask.cancel()
                            let currentStatus = self.locationManager.authorizationStatus
                            return currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways
                        }
                        
                        let currentStatus = self.locationManager.authorizationStatus
                        if currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways {
                            // Resume all waiting continuations (only once)
                            if !self.permissionResolved {
                                self.permissionResolved = true
                                for continuation in self.permissionContinuations {
                                    continuation.resume(returning: true)
                                }
                                self.permissionContinuations.removeAll()
                            }
                            delegateTask.cancel()
                            return true
                        }
                        if currentStatus != .notDetermined {
                            // Status changed but not authorized
                            if !self.permissionResolved {
                                self.permissionResolved = true
                                for continuation in self.permissionContinuations {
                                    continuation.resume(returning: false)
                                }
                                self.permissionContinuations.removeAll()
                            }
                            delegateTask.cancel()
                            return false
                        }
                    }
                    // Timeout - assume denied
                    if !self.permissionResolved {
                        self.permissionResolved = true
                        for continuation in self.permissionContinuations {
                            continuation.resume(returning: false)
                        }
                        self.permissionContinuations.removeAll()
                    }
                    delegateTask.cancel()
                    return false
                }
                
                // Race between delegate and timeout - return whichever completes first
                return await withTaskGroup(of: Bool.self) { group in
                    group.addTask {
                        await delegateTask.value
                    }
                    group.addTask {
                        await timeoutTask.value
                    }
                    
                    // Get the first result
                    let result = await group.next() ?? false
                    group.cancelAll()
                    return result
                }
            }.value
        default:
            return false
        }
    }
    
    nonisolated func getCurrentCountryCode() async throws -> String? {
        guard await requestLocationPermission() else {
            return defaultCountryCode
        }
        
        return try await Task { @MainActor [weak self] in
            guard let self = self else { throw NSError(domain: "LocationService", code: -1) }
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                self.locationManager.requestLocation()
            }
        }.value
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            Task { @MainActor [weak self] in
                self?.handleLocationUpdateFailure()
            }
            return
        }
        
        Task { @MainActor [weak self] in
            await self?.reverseGeocodeLocation(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor [weak self] in
            self?.handleLocationFailure()
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor [weak self] in
            self?.handleAuthorizationChange()
        }
    }
    
    // MARK: - Private Helpers
    
    /// Handles location update failure by resuming continuation with default country code
    /// Must be called on MainActor since it accesses continuation
    @MainActor
    private func handleLocationUpdateFailure() {
        continuation?.resume(returning: defaultCountryCode)
        continuation = nil
    }
    
    /// Reverse geocodes location to get country code
    /// Must be called on MainActor since it accesses continuation and locationManager
    @MainActor
    private func reverseGeocodeLocation(_ location: CLLocation) async {
        let defaultCode = defaultCountryCode
        
        do {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            let request = MKLocalSearch.Request()
            request.region = region
            request.naturalLanguageQuery = "location"
            
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            
            if let firstResult = response.mapItems.first {
                let countryCode = firstResult.placemark.isoCountryCode
                continuation?.resume(returning: countryCode ?? defaultCode)
            } else {
                continuation?.resume(returning: defaultCode)
            }
            continuation = nil
        } catch {
            continuation?.resume(throwing: error)
            continuation = nil
        }
    }
    
    /// Handles location failure by resuming continuation with default country code
    /// Must be called on MainActor since it accesses continuation
    @MainActor
    private func handleLocationFailure() {
        continuation?.resume(returning: defaultCountryCode)
        continuation = nil
    }
    
    /// Handles authorization status change
    /// Must be called on MainActor since it accesses locationManager and permissionContinuations
    @MainActor
    private func handleAuthorizationChange() {
        let status = locationManager.authorizationStatus
        let isAuthorized = status == .authorizedWhenInUse || status == .authorizedAlways
        
        // Resume all waiting continuations (only once)
        if !permissionResolved {
            permissionResolved = true
            for continuation in permissionContinuations {
                continuation.resume(returning: isAuthorized)
            }
            permissionContinuations.removeAll()
        }
    }
}
