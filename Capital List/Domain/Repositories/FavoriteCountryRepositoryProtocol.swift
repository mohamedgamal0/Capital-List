//
//  FavoriteCountryRepositoryProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Protocol for favorite country repository operations
/// Marked as Sendable to allow safe cross-actor usage
nonisolated protocol FavoriteCountryRepositoryProtocol: Sendable {
    func getFavoriteCountries() async throws -> [Country]
    func addFavoriteCountry(_ country: Country) async throws
    func removeFavoriteCountry(_ country: Country) async throws
    func isFavorite(_ country: Country) async throws -> Bool
    func canAddMore() async throws -> Bool
}

