//
//  Capital_ListApp.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI
import SwiftData

@main
struct Capital_ListApp: App {
    init() {
        AppLogger.info("App launching...")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main App Background Gradient
                LinearGradient(
                    colors: [
                        AppColors.gradientStart.opacity(0.1),
                        AppColors.gradientEnd.opacity(0.05),
                        AppColors.background
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ContentView()
            }
            .appTheme(DependencyContainer.shared.appTheme) // Apply theme manager
            .onAppear {
                AppLogger.success("App appeared on screen")
            }
        }
        .modelContainer(DependencyContainer.shared.modelContainer)
    }
}

