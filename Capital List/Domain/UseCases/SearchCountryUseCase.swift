//
//  SearchCountryUseCase.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor SearchCountryUseCase {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [Country] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        return try await repository.searchCountry(by: query)
    }
}

