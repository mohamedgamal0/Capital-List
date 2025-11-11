//
//  FavoriteCountryModel.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteCountryModel {
    @Attribute(.unique) var id: String
    var countryName: String
    var officialName: String?
    var capital: String?
    var currencies: String? // JSON encoded
    var cca2: String?
    var dateAdded: Date
    
    init(
        id: String = UUID().uuidString,
        countryName: String,
        officialName: String? = nil,
        capital: String? = nil,
        currencies: String? = nil,
        cca2: String? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.countryName = countryName
        self.officialName = officialName
        self.capital = capital
        self.currencies = currencies
        self.cca2 = cca2
        self.dateAdded = dateAdded
    }
    
    // Convert to Domain Model
    func toCountry() -> Country {
        let name = CountryName(
            common: countryName,
            official: officialName
        )
        
        var decodedCurrencies: [String: Currency]? = nil
        if let currenciesData = currencies?.data(using: .utf8),
           let currenciesDict = try? JSONDecoder().decode([String: CurrencyDTO].self, from: currenciesData) {
            decodedCurrencies = currenciesDict.mapValues { Currency(name: $0.name, symbol: $0.symbol) }
        }
        
        let capitals = capital != nil ? [capital!] : nil
        
        return Country(
            id: id,
            name: name,
            capital: capitals,
            currencies: decodedCurrencies,
            cca2: cca2
        )
    }
    
    // Create from Domain Model
    static func from(_ country: Country) -> FavoriteCountryModel {
        var currenciesJSON: String? = nil
        if let currencies = country.currencies {
            let currenciesDTO = currencies.mapValues { CurrencyDTO(name: $0.name, symbol: $0.symbol) }
            if let data = try? JSONEncoder().encode(currenciesDTO),
               let jsonString = String(data: data, encoding: .utf8) {
                currenciesJSON = jsonString
            }
        }
        
        return FavoriteCountryModel(
            id: country.id,
            countryName: country.name.common,
            officialName: country.name.official,
            capital: country.capital?.first,
            currencies: currenciesJSON,
            cca2: country.cca2?.uppercased()
        )
    }
}

