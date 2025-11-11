//
//  CountryRepository.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor CountryRepository: CountryRepositoryProtocol {
    private let apiService: APIService
    private var cachedCountries: [Country]?
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchAllCountries() async throws -> [Country] {
        if let cached = cachedCountries {
            return cached
        }
        
        let dtos: [CountryDTO] = try await apiService.fetch(endpoint: "all")
        let countries = dtos.map { $0.toDomain() }
        cachedCountries = countries
        return countries
    }
    
    func searchCountry(by name: String) async throws -> [Country] {
        let allCountries = try await fetchAllCountries()
        let searchTerm = name.lowercased().trimmingCharacters(in: .whitespaces)
        
        return allCountries.filter {
            $0.countryName.lowercased().contains(searchTerm) ||
            $0.name.official?.lowercased().contains(searchTerm) == true ||
            $0.cca2?.lowercased() == searchTerm
        }
    }
    
    func getCountry(by code: String) async throws -> Country? {
        let allCountries = try await fetchAllCountries()
        let upperCode = code.uppercased()
        let lowerCode = code.lowercased()
        
        return allCountries.first {
            $0.cca2?.uppercased() == upperCode || $0.countryName.lowercased() == lowerCode
        }
    }
}
