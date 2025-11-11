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
        CardView {
            HStack(spacing: AppSpacing.md) {
                Text("us")
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("us")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textPrimary)
                    
                    IconLabel(
                        icon: "building.2",
                        text: "country capital",
                        iconColor: AppColors.textSecondary,
                        textColor: AppColors.textSecondary,
                        fontSize: AppTypography.caption
                    )
                }
                
                Spacer()
            }
        }
    }
}

