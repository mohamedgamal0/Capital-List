//
//  CountriesListView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CountriesListView: View {
    // Static data
    private let countries: [Country] = [
        Country(name: "United States", capital: "Washington, D.C.", flag: "🇺🇸"),
        Country(name: "United Kingdom", capital: "London", flag: "🇬🇧"),
        Country(name: "France", capital: "Paris", flag: "🇫🇷"),
        Country(name: "Germany", capital: "Berlin", flag: "🇩🇪"),
        Country(name: "Japan", capital: "Tokyo", flag: "🇯🇵"),
        Country(name: "Canada", capital: "Ottawa", flag: "🇨🇦"),
        Country(name: "Australia", capital: "Canberra", flag: "🇦🇺"),
        Country(name: "Italy", capital: "Rome", flag: "🇮🇹"),
        Country(name: "Spain", capital: "Madrid", flag: "🇪🇸"),
        Country(name: "Brazil", capital: "Brasília", flag: "🇧🇷")
    ]
    
    var body: some View {
        List {
            ForEach(countries) { country in
                CountryRowView(country: country)
            }
        }
        .listStyle(.plain)
        .background(AppColors.background)
        .scrollContentBackground(.hidden)
        .listRowInsets(EdgeInsets(top: AppSpacing.xs, leading: AppSpacing.md, bottom: AppSpacing.xs, trailing: AppSpacing.md))
        .listRowBackground(Color.clear)
        .navigationTitle("Countries")
    }
}

#Preview {
    NavigationStack {
        CountriesListView()
    }
}

