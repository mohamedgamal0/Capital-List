//
//  DesignSystem.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

// MARK: - Colors
struct AppColors {
    // Primary Colors (from Assets)
    static let primary = Color("PrimaryColor")
    static let primaryDark = Color("PrimaryDarkColor")
    
    // Accent Colors (from Assets)
    static let accent = Color("AccentColor")
    static let success = Color("SuccessColor")
    static let warning = Color("WarningColor")
    static let error = Color("ErrorColor")
    
    // System Colors (adapts to light/dark mode automatically)
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    // Text Colors (adapts to light/dark mode automatically)
    static let textPrimary = Color(.label)
    static let textSecondary = Color(.secondaryLabel)
    static let textTertiary = Color(.tertiaryLabel)
    
    // Card Colors (from Assets)
    static let cardBackground = Color("CardBackgroundColor")
    static let cardShadow = Color("CardShadowColor")
    
    // Gradient Colors (using asset colors)
    static let gradientStart = Color("PrimaryColor")
    static let gradientEnd = Color("AccentColor")
}

// MARK: - Typography
struct AppTypography {
    // Display
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    static let title2 = Font.system(size: 22, weight: .bold, design: .default)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    
    // Body
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    
    // Labels
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
}

// MARK: - Shadows
struct AppShadows {
    static let small = Shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
    static let medium = Shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
    static let large = Shadow(color: AppColors.cardShadow, radius: 16, x: 0, y: 8)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Animations
struct AppAnimations {
    static let quick = Animation.easeInOut(duration: 0.2)
    static let standard = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.spring(response: 0.4, dampingFraction: 0.8)
}
