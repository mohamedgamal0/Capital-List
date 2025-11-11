//
//  GetCountryByCodeUseCase.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

actor GetCountryByCodeUseCase {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(code: String) async throws -> Country? {
        return try await repository.getCountry(by: code)
    }
}

