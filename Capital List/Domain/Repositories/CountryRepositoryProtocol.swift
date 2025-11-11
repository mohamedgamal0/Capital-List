//
//  CountryRepositoryProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

protocol CountryRepositoryProtocol {
    func fetchAllCountries() async throws -> [Country]
    func searchCountry(by name: String) async throws -> [Country]
    func getCountry(by code: String) async throws -> Country?
}

