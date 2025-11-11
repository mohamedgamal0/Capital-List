//
//  FavoriteCountryRepository.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftData

actor FavoriteCountryRepository: FavoriteCountryRepositoryProtocol {
    private let modelContext: ModelContext
    private let maxFavorites = 5
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getFavoriteCountries() async throws -> [Country] {
        let descriptor = FetchDescriptor<FavoriteCountryModel>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toCountry() }
    }
    
    func addFavoriteCountry(_ country: Country) async throws {
        guard let code = country.cca2?.uppercased() else {
            throw NSError(domain: "FavoriteCountryRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Country code is required"])
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
            throw NSError(domain: "FavoriteCountryRepository", code: 2, userInfo: [NSLocalizedDescriptionKey: "Maximum number of favorites reached"])
        }
        
        let model = FavoriteCountryModel.from(country)
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func removeFavoriteCountry(_ country: Country) async throws {
        guard let code = country.cca2?.uppercased() else {
            throw NSError(domain: "FavoriteCountryRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Country code is required"])
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
    
    func isFavorite(_ country: Country) async throws -> Bool {
        guard let code = country.cca2?.uppercased() else { return false }
        let descriptor = FetchDescriptor<FavoriteCountryModel>(
            predicate: #Predicate { $0.cca2 == code }
        )
        let models = try modelContext.fetch(descriptor)
        return !models.isEmpty
    }
    
    func canAddMore() async throws -> Bool {
        let favorites = try await getFavoriteCountries()
        return favorites.count < maxFavorites
    }
}

