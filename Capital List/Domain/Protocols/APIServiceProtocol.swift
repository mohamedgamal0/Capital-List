//
//  APIServiceProtocol.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// Protocol for API service operations
/// Allows dependency injection and better testability
/// The protocol is Sendable, but individual return types are handled by the implementation
protocol APIServiceProtocol: Sendable {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}

