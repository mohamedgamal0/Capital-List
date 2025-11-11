//
//  DependencyContainer.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftData

/// Dependency Injection Container for modular architecture

final class DependencyContainer {
    
    // MARK: - Shared Instances
    static let shared = DependencyContainer()
    
    // MARK: - SwiftData
    private(set) lazy var modelContainer: ModelContainer = {
        let schema = Schema([FavoriteCountryModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private(set) lazy var modelContext: ModelContext = {
        modelContainer.mainContext
    }()
    
    // MARK: - Core Services
    private(set) lazy var apiService: APIService = {
        APIService()
    }()
    
    private(set) lazy var locationService: LocationServiceProtocol = {
        LocationService()
    }()
    
    // MARK: - Theme
    private(set) lazy var appTheme: AppTheme = {
        AppTheme()
    }()
    
    // MARK: - Repositories
    private(set) lazy var countryRepository: CountryRepositoryProtocol = {
        CountryRepository(apiService: apiService)
    }()
    
    private(set) lazy var favoriteCountryRepository: FavoriteCountryRepositoryProtocol = {
        FavoriteCountryRepository(modelContext: modelContext)
    }()
    
    // MARK: - Use Cases
    private(set) lazy var fetchAllCountriesUseCase: FetchAllCountriesUseCase = {
        FetchAllCountriesUseCase(repository: countryRepository)
    }()
    
    private(set) lazy var searchCountryUseCase: SearchCountryUseCase = {
        SearchCountryUseCase(repository: countryRepository)
    }()
    
    private(set) lazy var getCountryByCodeUseCase: GetCountryByCodeUseCase = {
        GetCountryByCodeUseCase(repository: countryRepository)
    }()
    
    private(set) lazy var favoriteCountriesUseCase: FavoriteCountriesUseCase = {
        FavoriteCountriesUseCase(repository: favoriteCountryRepository)
    }()
    
    // MARK: - View Models
    func makeCountriesViewModel() -> CountriesViewModel {
        CountriesViewModel(
            favoriteUseCase: favoriteCountriesUseCase,
            getCountryByCodeUseCase: getCountryByCodeUseCase,
            locationService: locationService
        )
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchUseCase: searchCountryUseCase)
    }
    
    private init() {}
}

