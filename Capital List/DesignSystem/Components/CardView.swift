//
//  CardView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = AppCornerRadius.medium
    var shadow: Shadow = AppShadows.small
    var backgroundColor: Color = AppColors.cardBackground
    var padding: CGFloat = AppSpacing.md
    
    init(
        cornerRadius: CGFloat = AppCornerRadius.medium,
        shadow: Shadow = AppShadows.small,
        backgroundColor: Color = AppColors.cardBackground,
        padding: CGFloat = AppSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

