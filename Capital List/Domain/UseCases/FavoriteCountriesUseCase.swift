//
//  FavoriteCountriesUseCase.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor FavoriteCountriesUseCase {
    private let repository: FavoriteCountryRepositoryProtocol
    
    init(repository: FavoriteCountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func getFavorites() async throws -> [Country] {
        return try await repository.getFavoriteCountries()
    }
    
    func addFavorite(_ country: Country) async throws {
        let canAdd = try await repository.canAddMore()
        guard canAdd else {
            throw FavoriteCountryError.maxLimitReached
        }
        try await repository.addFavoriteCountry(country)
    }
    
    func removeFavorite(_ country: Country) async throws {
        try await repository.removeFavoriteCountry(country)
    }
    
    func isFavorite(_ country: Country) async throws -> Bool {
        return try await repository.isFavorite(country)
    }
    
    func canAddMore() async throws -> Bool {
        return try await repository.canAddMore()
    }
}

enum FavoriteCountryError: LocalizedError {
    case maxLimitReached
    
    var errorDescription: String? {
        switch self {
        case .maxLimitReached:
            return "You can only add up to 5 countries to your favorites."
        }
    }
}

