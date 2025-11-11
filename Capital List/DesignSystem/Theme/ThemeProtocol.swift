//
//  ThemeProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

// MARK: - Theme Protocol
protocol ThemeProtocol: Observable {
    var colorScheme: ColorScheme? { get set }
    
    func setLightMode()
    func setDarkMode()
    func setSystemMode()
    
    var isLightMode: Bool { get }
    var isDarkMode: Bool { get }
    var isSystemMode: Bool { get }
}

