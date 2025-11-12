//
//  LocationServiceProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Protocol for location services
/// Domain layer should not depend on CoreLocation framework
protocol LocationServiceProtocol {
    func requestLocationPermission() async -> Bool
    func getCurrentCountryCode() async throws -> String?
}

