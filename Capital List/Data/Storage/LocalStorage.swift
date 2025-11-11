//
//  LocalStorage.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor LocalStorage {
    private let userDefaults: UserDefaults
    private let favoritesKey = "favorite_countries"
    private let maxFavorites = 5
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveFavoriteCountries(_ countries: [Country]) throws {
        let data = try JSONEncoder().encode(countries)
        userDefaults.set(data, forKey: favoritesKey)
    }
    
    func loadFavoriteCountries() throws -> [Country] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }
        return try JSONDecoder().decode([Country].self, from: data)
    }
    
    func canAddMore() -> Bool {
        ((try? loadFavoriteCountries()) ?? []).count < maxFavorites
    }
}

