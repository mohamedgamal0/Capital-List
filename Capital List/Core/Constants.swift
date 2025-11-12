//
//  Constants.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import CoreLocation

/// Application-wide constants
nonisolated enum AppConstants {
    
    // MARK: - Location Service
    enum Location {
        static let defaultCountryCode = "US"
        static let permissionCheckDelay: TimeInterval = 0.1
        static let locationAccuracy = kCLLocationAccuracyReduced
    }
    
    // MARK: - API
    enum API {
        static let baseURL = "https://restcountries.com/v3.1"
        static let requiredFields = "name,capital,currencies,cca2"
    }
    
    // MARK: - Favorites
    enum Favorites {
        static let maxCount = 5
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let countryCodeRequired = "Country code is required"
        static let maxFavoritesReached = "Maximum number of favorites reached"
        static let invalidURL = "Invalid URL"
        static let invalidResponse = "Invalid response from server"
        static let decodingFailed = "Failed to decode response"
        static let networkError = "Network error"
    }
}

