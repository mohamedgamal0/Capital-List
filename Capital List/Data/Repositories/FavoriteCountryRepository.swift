//
//  FavoriteCountryRepository.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftData

final class FavoriteCountryRepository: FavoriteCountryRepositoryProtocol, @unchecked Sendable {
    
    // MARK: - Properties
    
    /// ModelContext is not Sendable, but safe to use within MainActor context
    /// Using nonisolated(unsafe) as recommended for SwiftData ModelContext in MainActor-isolated types
    nonisolated(unsafe) private let modelContext: ModelContext
    private let maxFavorites: Int
    
    // MARK: - Initialization
    
    init(
        modelContext: ModelContext,
        maxFavorites: Int = AppConstants.Favorites.maxCount
    ) {
        self.modelContext = modelContext
        self.maxFavorites = maxFavorites
    }
    
    nonisolated func getFavoriteCountries() async throws -> [Country] {
        try await MainActor.run {
            let descriptor = FetchDescriptor<FavoriteCountryModel>(
                sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
            )
            let models = try modelContext.fetch(descriptor)
            return models.map { $0.toCountry() }
        }
    }
    
    nonisolated func addFavoriteCountry(_ country: Country) async throws {
        try await MainActor.run {
            guard let code = country.cca2?.uppercased() else {
                throw FavoriteCountryError.countryCodeRequired
            }
            
            // Check if already exists
            let descriptor = FetchDescriptor<FavoriteCountryModel>(
                predicate: #Predicate { $0.cca2 == code }
            )
            let existing = try modelContext.fetch(descriptor)
            guard existing.isEmpty else {
                return
            }
            
            // Check if we can add more
            let allModels = try modelContext.fetch(FetchDescriptor<FavoriteCountryModel>())
            guard allModels.count < maxFavorites else {
                throw FavoriteCountryError.maxFavoritesReached
            }
            
            let model = FavoriteCountryModel.from(country)
            modelContext.insert(model)
            try modelContext.save()
        }
    }
    
    nonisolated func removeFavoriteCountry(_ country: Country) async throws {
        try await MainActor.run {
            guard let code = country.cca2?.uppercased() else {
                throw FavoriteCountryError.countryCodeRequired
            }
            
            let descriptor = FetchDescriptor<FavoriteCountryModel>(
                predicate: #Predicate { $0.cca2 == code }
            )
            let models = try modelContext.fetch(descriptor)
            for model in models {
                modelContext.delete(model)
            }
            try modelContext.save()
        }
    }
    
    nonisolated func isFavorite(_ country: Country) async throws -> Bool {
        try await MainActor.run {
            guard let code = country.cca2?.uppercased() else { return false }
            let descriptor = FetchDescriptor<FavoriteCountryModel>(
                predicate: #Predicate { $0.cca2 == code }
            )
            let models = try modelContext.fetch(descriptor)
            return !models.isEmpty
        }
    }
    
    nonisolated func canAddMore() async throws -> Bool {
        let favorites = try await getFavoriteCountries()
        return favorites.count < maxFavorites
    }
}

