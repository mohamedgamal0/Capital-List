//
//  IconLabel.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct IconLabel: View {
    let icon: String
    let text: String
    var iconColor: Color = AppColors.primary
    var textColor: Color = AppColors.textSecondary
    var fontSize: Font = AppTypography.subheadline
    var spacing: CGFloat = AppSpacing.sm
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(iconColor)
            Text(text)
                .font(fontSize)
                .foregroundColor(textColor)
        }
    }
}
