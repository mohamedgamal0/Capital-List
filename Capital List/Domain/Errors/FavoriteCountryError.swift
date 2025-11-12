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
            return AppConstants.ErrorMessages.countryCodeRequired
        case .maxFavoritesReached:
            return AppConstants.ErrorMessages.maxFavoritesReached
        }
    }
}

