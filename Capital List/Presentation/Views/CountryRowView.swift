//
//  CountryRowView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Text(country.flag)
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(country.name)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(country.capital)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    CountryRowView(country: Country(name: "United States", capital: "Washington, D.C.", flag: "🇺🇸"))
}

