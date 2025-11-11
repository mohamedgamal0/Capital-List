//
//  FetchAllCountriesUseCase.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor FetchAllCountriesUseCase {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Country] {
        return try await repository.fetchAllCountries()
    }
}

