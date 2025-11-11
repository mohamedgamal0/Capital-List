//
//  CountriesViewModel.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class CountriesViewModel {
    var favoriteCountries: [Country] = []
    var isLoading = false
    var errorMessage: String?
    var canAddMore = true
    
    private let favoriteUseCase: FavoriteCountriesUseCase
    private let getCountryByCodeUseCase: GetCountryByCodeUseCase
    private let locationService: LocationServiceProtocol
    
    init(
        favoriteUseCase: FavoriteCountriesUseCase,
        getCountryByCodeUseCase: GetCountryByCodeUseCase,
        locationService: LocationServiceProtocol
    ) {
        self.favoriteUseCase = favoriteUseCase
        self.getCountryByCodeUseCase = getCountryByCodeUseCase
        self.locationService = locationService
    }
    
    func loadFavoriteCountries() async {
        AppLogger.info("Loading favorite countries")
        isLoading = true
        errorMessage = nil
        
        do {
            let favorites = try await favoriteUseCase.getFavorites()
            favoriteCountries = favorites
            canAddMore = try await favoriteUseCase.canAddMore()
            AppLogger.success("Loaded \(favorites.count) favorite countries, canAddMore: \(canAddMore)")
        } catch {
            AppLogger.error("Error loading favorites: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addFavoriteCountry(_ country: Country) async {
        AppLogger.info("Adding favorite country: \(country.countryName)")
        do {
            try await favoriteUseCase.addFavorite(country)
            await loadFavoriteCountries()
            AppLogger.success("Successfully added \(country.countryName)")
        } catch {
            AppLogger.error("Error adding favorite: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func removeFavoriteCountry(_ country: Country) async {
        AppLogger.info("Removing favorite country: \(country.countryName)")
        isLoading = true
        errorMessage = nil
        
        do {
            // Remove from storage
            try await favoriteUseCase.removeFavorite(country)
            
            // Reload favorites to get updated list
            let favorites = try await favoriteUseCase.getFavorites()
            
            // Update state (we're already on @MainActor)
            favoriteCountries = favorites
            canAddMore = try await favoriteUseCase.canAddMore()
            
            AppLogger.success("Successfully removed \(country.countryName). Remaining: \(favorites.count)")
            AppLogger.debug("Updated viewModel.favoriteCountries.count: \(favoriteCountries.count)")
        } catch {
            AppLogger.error("Error removing favorite: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadInitialCountry() async {
        AppLogger.info("Loading initial country based on location")
        do {
            let countryCode = try await locationService.getCurrentCountryCode()
            guard let code = countryCode else {
                AppLogger.warning("No country code from location service, loading default")
                await loadDefaultCountry()
                return
            }
            
            AppLogger.debug("Got country code: \(code), fetching country details")
            let country = try await getCountryByCodeUseCase.execute(code: code)
            if let country = country {
                AppLogger.info("Found country: \(country.countryName), adding to favorites")
                await addFavoriteCountry(country)
            } else {
                AppLogger.warning("Country not found for code: \(code), loading default")
                await loadDefaultCountry()
            }
        } catch {
            AppLogger.error("Error loading initial country: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            await loadDefaultCountry()
        }
    }
    
    private func loadDefaultCountry() async {
        AppLogger.info("Loading default country (US)")
        let defaultCountry = try? await getCountryByCodeUseCase.execute(code: "US")
        if let country = defaultCountry {
            AppLogger.success("Found default country: \(country.countryName)")
            await addFavoriteCountry(country)
        } else {
            AppLogger.error("Failed to load default country")
        }
    }
}

