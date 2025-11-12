//
//  FavoriteCountryError.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Errors for favorite country operations
/// Defined in Domain layer to be shared across layers
enum FavoriteCountryError: LocalizedError {
    case countryCodeRequired
    case maxFavoritesReached
    
    var errorDescription: String? {
        switch self {
        case .countryCodeRequired:
            return "Country code is required"
        case .maxFavoritesReached:
            return "Maximum number of favorites reached"
        }
    }
}

