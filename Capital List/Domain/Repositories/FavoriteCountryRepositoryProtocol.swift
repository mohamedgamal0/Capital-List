//
//  FavoriteCountryRepositoryProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

protocol FavoriteCountryRepositoryProtocol {
    func getFavoriteCountries() async throws -> [Country]
    func addFavoriteCountry(_ country: Country) async throws
    func removeFavoriteCountry(_ country: Country) async throws
    func isFavorite(_ country: Country) async throws -> Bool
    func canAddMore() async throws -> Bool
}

