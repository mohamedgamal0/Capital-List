//
//  ThemeToggle.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

// MARK: - Theme Toggle Component
struct ThemeToggle: View {
    @Bindable var theme: AppTheme
    var showLabel: Bool = true
    var style: ToggleStyle = .switch
    
    init(theme: AppTheme = DependencyContainer.shared.appTheme, showLabel: Bool = true, style: ToggleStyle = .switch) {
        self.theme = theme
        self.showLabel = showLabel
        self.style = style
    }
    
    enum ToggleStyle {
        case `switch`
        case button
        case segmented
    }
    
    var body: some View {
        switch style {
        case .switch:
            switchStyle
        case .button:
            buttonStyle
        case .segmented:
            segmentedStyle
        }
    }
    
    // MARK: - Switch Style
    private var switchStyle: some View {
        HStack(spacing: AppSpacing.md) {
            if showLabel {
                Label {
                    Text("Dark Mode")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textPrimary)
                } icon: {
                    Image(systemName: theme.isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(theme.isDarkMode ? AppColors.primary : AppColors.warning)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { !theme.isSystemMode && theme.isDarkMode },
                set: { newValue in
                    if newValue {
                        theme.setDarkMode()
                    } else {
                        theme.setLightMode()
                    }
                }
            ))
            .tint(AppColors.primary)
        }
    }
    
    // MARK: - Button Style
    private var buttonStyle: some View {
        HStack(spacing: AppSpacing.sm) {
            // Light Mode Button
            Button(action: {
                theme.setLightMode()
            }) {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 16, weight: .medium))
                    if showLabel {
                        Text("Light")
                            .font(AppTypography.subheadline)
                    }
                }
                .foregroundColor(theme.isLightMode ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    theme.isLightMode ? AppColors.primary : AppColors.cardBackground
                )
                .cornerRadius(AppCornerRadius.small)
            }
            
            // Dark Mode Button
            Button(action: {
                theme.setDarkMode()
            }) {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 16, weight: .medium))
                    if showLabel {
                        Text("Dark")
                            .font(AppTypography.subheadline)
                    }
                }
                .foregroundColor(theme.isDarkMode ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    theme.isDarkMode ? AppColors.primary : AppColors.cardBackground
                )
                .cornerRadius(AppCornerRadius.small)
            }
            
            // System Mode Button
            Button(action: {
                theme.setSystemMode()
            }) {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 16, weight: .medium))
                    if showLabel {
                        Text("Auto")
                            .font(AppTypography.subheadline)
                    }
                }
                .foregroundColor(theme.isSystemMode ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    theme.isSystemMode ? AppColors.primary : AppColors.cardBackground
                )
                .cornerRadius(AppCornerRadius.small)
            }
        }
    }
    
    // MARK: - Segmented Style
    private var segmentedStyle: some View {
        Picker("Theme", selection: Binding(
            get: {
                if theme.isSystemMode { return 0 }
                return theme.isDarkMode ? 2 : 1
            },
            set: { index in
                switch index {
                case 0: theme.setSystemMode()
                case 1: theme.setLightMode()
                case 2: theme.setDarkMode()
                default: break
                }
            }
        )) {
            HStack {
                Image(systemName: "circle.lefthalf.filled")
                Text("Auto")
            }
            .tag(0)
            
            HStack {
                Image(systemName: "sun.max.fill")
                Text("Light")
            }
            .tag(1)
            
            HStack {
                Image(systemName: "moon.fill")
                Text("Dark")
            }
            .tag(2)
        }
        .pickerStyle(.segmented)
    }
}

// MARK: - Compact Theme Toggle (Icon Only)
struct CompactThemeToggle: View {
    @Bindable var theme: AppTheme
    
    init(theme: AppTheme = DependencyContainer.shared.appTheme) {
        self.theme = theme
    }
    
    var body: some View {
        Menu {
            Button(action: { theme.setLightMode() }) {
                Label("Light Mode", systemImage: "sun.max.fill")
            }
            
            Button(action: { theme.setDarkMode() }) {
                Label("Dark Mode", systemImage: "moon.fill")
            }
            
            Button(action: { theme.setSystemMode() }) {
                Label("System", systemImage: "circle.lefthalf.filled")
            }
        } label: {
            Image(systemName: themeIcon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(AppColors.primary)
                .frame(width: 44, height: 44)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Circle())
        }
    }
    
    private var themeIcon: String {
        if theme.isSystemMode {
            return "circle.lefthalf.filled"
        }
        return theme.isDarkMode ? "moon.fill" : "sun.max.fill"
    }
}

