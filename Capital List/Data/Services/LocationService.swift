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
    
    private let locationManager: CLLocationManager
    private var continuation: CheckedContinuation<String?, Error>?
    private let defaultCountryCode: String
    private let permissionCheckDelay: TimeInterval
    
    // MARK: - Initialization
    
    init(
        locationManager: CLLocationManager = CLLocationManager(),
        defaultCountryCode: String = AppConstants.Location.defaultCountryCode,
        permissionCheckDelay: TimeInterval = AppConstants.Location.permissionCheckDelay
    ) {
        self.locationManager = locationManager
        self.defaultCountryCode = defaultCountryCode
        self.permissionCheckDelay = permissionCheckDelay
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = AppConstants.Location.locationAccuracy
    }
    
    // MARK: - LocationServiceProtocol Implementation
    
    func requestLocationPermission() async -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return await withCheckedContinuation { continuation in
                DispatchQueue.main.asyncAfter(deadline: .now() + self.permissionCheckDelay) {
                    let newStatus = self.locationManager.authorizationStatus
                    let isAuthorized = newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways
                    continuation.resume(returning: isAuthorized)
                }
            }
        default:
            return false
        }
    }
    
    func getCurrentCountryCode() async throws -> String? {
        guard await requestLocationPermission() else {
            return defaultCountryCode
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
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
            self?.reverseGeocodeLocation(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor [weak self] in
            self?.handleLocationFailure()
        }
    }
    
    // MARK: - Private Helpers
    
    private func handleLocationUpdateFailure() {
        continuation?.resume(returning: defaultCountryCode)
        continuation = nil
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        let defaultCode = defaultCountryCode
        
        Task {
            do {
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                
                let request = MKLocalSearch.Request()
                request.region = region
                request.naturalLanguageQuery = "location"
                
                let search = MKLocalSearch(request: request)
                let response = try await search.start()
                
                if let firstResult = response.mapItems.first {
                    let countryCode: String?
                    countryCode = firstResult.placemark.isoCountryCode
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
    }
    
    private func handleLocationFailure() {
            continuation?.resume(returning: defaultCountryCode)
            continuation = nil
    }
}
