//
//  PrimaryButton.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
            }
            .primaryButtonStyle(isEnabled: isEnabled, isLoading: isLoading)
        }
    }
}

