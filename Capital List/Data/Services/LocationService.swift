//
//  LocationService.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager: CLLocationManager
    private var continuation: CheckedContinuation<String?, Error>?
    private let defaultCountryCode = "US" // Default to United States if location denied
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }
    
    func requestLocationPermission() async -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return await withCheckedContinuation { continuation in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let newStatus = self.locationManager.authorizationStatus
                    continuation.resume(returning: newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways)
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

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            Task { @MainActor in
                continuation?.resume(returning: defaultCountryCode)
                continuation = nil
            }
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            Task { @MainActor in
                if let error = error {
                    self.continuation?.resume(throwing: error)
                    self.continuation = nil
                    return
                }
                
                let countryCode = placemarks?.first?.isoCountryCode ?? self.defaultCountryCode
                self.continuation?.resume(returning: countryCode)
                self.continuation = nil
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            continuation?.resume(returning: defaultCountryCode)
            continuation = nil
        }
    }
}
