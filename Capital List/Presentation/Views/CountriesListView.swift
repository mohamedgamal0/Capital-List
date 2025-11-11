//
//  CountriesListView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CountriesListView: View {
    // Static data
    private let countries: [Country] = []
    
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

