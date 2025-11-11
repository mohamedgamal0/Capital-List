//
//  FavoriteCountryRepository.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor FavoriteCountryRepository: FavoriteCountryRepositoryProtocol {
    private let localStorage: LocalStorage
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    func getFavoriteCountries() async throws -> [Country] {
        try await localStorage.loadFavoriteCountries()
    }
    
    func addFavoriteCountry(_ country: Country) async throws {
        guard let code = country.cca2?.uppercased() else {
            throw NSError(domain: "FavoriteCountryRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Country code is required"])
        }
        
        var favorites = try await localStorage.loadFavoriteCountries()
        guard !favorites.contains(where: { $0.cca2?.uppercased() == code }) else {
            return
        }
        
        favorites.append(country)
        try await localStorage.saveFavoriteCountries(favorites)
    }
    
    func removeFavoriteCountry(_ country: Country) async throws {
        guard let code = country.cca2?.uppercased() else {
            throw NSError(domain: "FavoriteCountryRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Country code is required"])
        }
        
        var favorites = try await localStorage.loadFavoriteCountries()
        favorites.removeAll { $0.cca2?.uppercased() == code }
        try await localStorage.saveFavoriteCountries(favorites)
    }
    
    func isFavorite(_ country: Country) async throws -> Bool {
        guard let code = country.cca2?.uppercased() else { return false }
        let favorites = try await localStorage.loadFavoriteCountries()
        return favorites.contains { $0.cca2?.uppercased() == code }
    }
    
    func canAddMore() async throws -> Bool {
        await localStorage.canAddMore()
    }
}

