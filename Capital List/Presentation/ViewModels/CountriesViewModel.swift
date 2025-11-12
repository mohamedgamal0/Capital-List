//
//  CountriesViewModel.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class CountriesViewModel {
    var favoriteCountries: [Country] = []
    var isLoading = false
    var errorMessage: String?
    var canAddMore = true
    
    private let favoriteUseCase: FavoriteCountriesUseCase
    private let getCountryByCodeUseCase: GetCountryByCodeUseCase
    private let locationService: LocationServiceProtocol
    private let logger: LoggerProtocol
    
    init(
        favoriteUseCase: FavoriteCountriesUseCase,
        getCountryByCodeUseCase: GetCountryByCodeUseCase,
        locationService: LocationServiceProtocol,
        logger: LoggerProtocol
    ) {
        self.favoriteUseCase = favoriteUseCase
        self.getCountryByCodeUseCase = getCountryByCodeUseCase
        self.locationService = locationService
        self.logger = logger
    }
    
    func loadFavoriteCountries() async {
        logger.info("Loading favorite countries")
        isLoading = true
        errorMessage = nil
        
        do {
            let favorites = try await favoriteUseCase.getFavorites()
            favoriteCountries = favorites
            canAddMore = try await favoriteUseCase.canAddMore()
            logger.success("Loaded \(favorites.count) favorite countries, canAddMore: \(canAddMore)")
        } catch {
            logger.error("Error loading favorites: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addFavoriteCountry(_ country: Country) async {
        logger.info("Adding favorite country: \(country.countryName)")
        do {
            try await favoriteUseCase.addFavorite(country)
            await loadFavoriteCountries()
            logger.success("Successfully added \(country.countryName)")
        } catch {
            logger.error("Error adding favorite: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func removeFavoriteCountry(_ country: Country) async {
        logger.info("Removing favorite country: \(country.countryName)")
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
            
            logger.success("Successfully removed \(country.countryName). Remaining: \(favorites.count)")
            logger.debug("Updated viewModel.favoriteCountries.count: \(favoriteCountries.count)")
        } catch {
            logger.error("Error removing favorite: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadInitialCountry() async {
        logger.info("Loading initial country based on location")
        do {
            let countryCode = try await locationService.getCurrentCountryCode()
            guard let code = countryCode else {
                logger.warning("No country code from location service, loading default")
                await loadDefaultCountry()
                return
            }
            
            logger.debug("Got country code: \(code), fetching country details")
            let country = try await getCountryByCodeUseCase.execute(code: code)
            if let country = country {
                logger.info("Found country: \(country.countryName), adding to favorites")
                await addFavoriteCountry(country)
            } else {
                logger.warning("Country not found for code: \(code), loading default")
                await loadDefaultCountry()
            }
        } catch {
            logger.error("Error loading initial country: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            await loadDefaultCountry()
        }
    }
    
    private func loadDefaultCountry() async {
        logger.info("Loading default country (US)")
        let defaultCountry = try? await getCountryByCodeUseCase.execute(code: "US")
        if let country = defaultCountry {
            logger.success("Found default country: \(country.countryName)")
            await addFavoriteCountry(country)
        } else {
            logger.error("Failed to load default country")
        }
    }
}

