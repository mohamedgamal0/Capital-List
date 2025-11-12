//
//  CountryRepositoryProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Protocol for country repository operations
/// Marked as Sendable to allow safe cross-actor usage
nonisolated protocol CountryRepositoryProtocol: Sendable {
    func fetchAllCountries() async throws -> [Country]
    func searchCountry(by name: String) async throws -> [Country]
    func getCountry(by code: String) async throws -> Country?
}

