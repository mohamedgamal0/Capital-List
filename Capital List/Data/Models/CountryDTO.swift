//
//  CountryDTO.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

struct CountryDTO: Codable {
    let name: CountryNameDTO
    let capital: [String]?
    let currencies: [String: CurrencyDTO]?
    let cca2: String?
    
    enum CodingKeys: String, CodingKey {
        case name, capital, currencies, cca2
    }
}

struct CountryNameDTO: Codable {
    let common: String
    let official: String?
}

struct CurrencyDTO: Codable {
    let name: String?
    let symbol: String?
}

extension CountryDTO: DomainConvertible {
    func toDomain() -> Country {
        Country(
            name: CountryName(common: name.common, official: name.official),
            capital: capital,
            currencies: currencies?.mapValues { Currency(name: $0.name, symbol: $0.symbol) },
            cca2: cca2
        )
    }
}

