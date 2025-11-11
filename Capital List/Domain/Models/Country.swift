//
//  Country.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

// MARK: - Country (v3.1 API Structure)
struct Country: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: CountryName
    let capital: [String]?
    let currencies: [String: Currency]?
    let cca2: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case capital
        case currencies
        case cca2
    }
    
    init(id: String = UUID().uuidString, name: CountryName, capital: [String]?, currencies: [String: Currency]?, cca2: String?) {
        self.id = id
        self.name = name
        self.capital = capital
        self.currencies = currencies
        self.cca2 = cca2
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.name = try container.decode(CountryName.self, forKey: .name)
        self.capital = try container.decodeIfPresent([String].self, forKey: .capital)
        self.currencies = try container.decodeIfPresent([String: Currency].self, forKey: .currencies)
        self.cca2 = try container.decodeIfPresent(String.self, forKey: .cca2)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(capital, forKey: .capital)
        try container.encodeIfPresent(currencies, forKey: .currencies)
        try container.encodeIfPresent(cca2, forKey: .cca2)
    }
    
    // Convenience properties for backward compatibility
    var countryName: String {
        name.common
    }
    
    var currencyDisplay: String {
        guard let currencies = currencies, !currencies.isEmpty else {
            return "N/A"
        }
        return currencies.map { code, currency in
            "\(currency.name ?? "N/A") (\(code))"
        }.joined(separator: ", ")
    }
    
    var capitalDisplay: String {
        capital?.first ?? "N/A"
    }
    
    var alpha2Code: String? {
        cca2
    }
}

// MARK: - CountryName (v3.1 API Structure)
struct CountryName: Codable, Equatable, Hashable {
    let common: String
    let official: String?
    
    enum CodingKeys: String, CodingKey {
        case common
        case official
    }
}

// MARK: - Currency (v3.1 API Structure)
struct Currency: Codable, Equatable, Hashable {
    let name: String?
    let symbol: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
    }
}

