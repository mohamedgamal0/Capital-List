//
//  AppTheme.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI
import Observation

@Observable
final class AppTheme: AppThemeProtocol {
    static let shared = AppTheme()
    
    var colorScheme: ColorScheme? = nil {
        didSet {
        }
    }
    
    private init() {
        colorScheme = nil
    }
    
    /// Set app to light mode
    func setLightMode() {
        colorScheme = .light
    }
    
    /// Set app to dark mode
    func setDarkMode() {
        colorScheme = .dark
    }
    
    /// Use system color scheme (automatic)
    func setSystemMode() {
        colorScheme = nil
    }
    
    var isLightMode: Bool {
        colorScheme == .light
    }
    
    var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var isSystemMode: Bool {
        colorScheme == nil
    }
}

// MARK: - Theme Modifier
struct ThemeModifier: ViewModifier {
    @Bindable var theme: AppTheme
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(theme.colorScheme)
    }
}

extension View {
    func appTheme(_ theme: AppTheme = AppTheme.shared) -> some View {
        modifier(ThemeModifier(theme: theme))
    }
}
