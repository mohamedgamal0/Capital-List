//
//  DependencyContainerProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Protocol for dependency injection container
/// Allows better testability by enabling mock containers
protocol DependencyContainerProtocol {
    func makeCountriesViewModel() -> CountriesViewModel
    func makeSearchViewModel() -> SearchViewModel
}

