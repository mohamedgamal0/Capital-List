//
//  LocationServiceProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func requestLocationPermission() async -> Bool
    func getCurrentCountryCode() async throws -> String?
}

