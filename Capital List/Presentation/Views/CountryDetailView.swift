//
//  CountryDetailView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [AppColors.background, AppColors.secondaryBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Header Card
                    CardView(
                        cornerRadius: AppCornerRadius.large,
                        shadow: AppShadows.medium,
                        backgroundColor: AppColors.cardBackground,
                        padding: AppSpacing.lg
                    ) {
                        VStack(spacing: AppSpacing.md) {
                            // Flag Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.primary.opacity(0.2), AppColors.accent.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "flag.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [AppColors.primary, AppColors.accent],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            VStack(spacing: AppSpacing.xs) {
                                Text(country.countryName)
                                    .font(AppTypography.largeTitle)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                if let code = country.cca2 {
                                    Text(code)
                                        .font(AppTypography.title3)
                                        .foregroundColor(AppColors.textSecondary)
                                        .padding(.horizontal, AppSpacing.md)
                                        .padding(.vertical, AppSpacing.xs)
                                        .background(AppColors.primary.opacity(0.1))
                                        .cornerRadius(AppCornerRadius.small)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.md)
                    
                    // Details Sections
                    VStack(spacing: AppSpacing.md) {
                        DetailSection(
                            title: "Capital City",
                            value: country.capitalDisplay,
                            icon: "building.2.fill",
                            iconColor: AppColors.primary
                        )
                        
                        DetailSection(
                            title: "Currency",
                            value: country.currencyDisplay,
                            icon: "dollarsign.circle.fill",
                            iconColor: AppColors.accent
                        )
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailSection: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = AppColors.primary
    
    var body: some View {
        CardView(
            cornerRadius: AppCornerRadius.medium,
            shadow: AppShadows.small,
            backgroundColor: AppColors.cardBackground
        ) {
            HStack(spacing: AppSpacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(value)
                        .font(AppTypography.bodyBold)
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Spacer()
            }
        }
    }
}

