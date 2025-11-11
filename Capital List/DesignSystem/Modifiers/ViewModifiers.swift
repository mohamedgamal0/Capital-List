//
//  ViewModifiers.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

// MARK: - Primary Button Modifier
struct PrimaryButtonModifier: ViewModifier {
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    func body(content: Content) -> some View {
        content
            .font(AppTypography.bodyBold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: isEnabled ? [AppColors.primary, AppColors.primaryDark] : [Color.gray.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(AppCornerRadius.medium)
            .disabled(!isEnabled || isLoading)
            .opacity(isEnabled ? 1.0 : 0.6)
    }
}

extension View {
    func primaryButtonStyle(isEnabled: Bool = true, isLoading: Bool = false) -> some View {
        modifier(PrimaryButtonModifier(isEnabled: isEnabled, isLoading: isLoading))
    }
}

