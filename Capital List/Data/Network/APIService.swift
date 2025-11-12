//
//  APIService.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

/// API-related errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppConstants.ErrorMessages.invalidURL
        case .invalidResponse:
            return AppConstants.ErrorMessages.invalidResponse
        case .httpError(let code):
            return "HTTP error with code: \(code)"
        case .decodingError(let error):
            return "\(AppConstants.ErrorMessages.decodingFailed): \(error.localizedDescription)"
        case .networkError(let error):
            return "\(AppConstants.ErrorMessages.networkError): \(error.localizedDescription)"
        }
    }
}

/// API service for making network requests

actor APIService: APIServiceProtocol {
    
    // MARK: - Properties
    
    private let baseURL: String
    private let session: URLSession
    private let requiredFields: String
    
    // MARK: - Initialization
    
    init(
        baseURL: String = AppConstants.API.baseURL,
        session: URLSession = .shared,
        requiredFields: String = AppConstants.API.requiredFields
    ) {
        self.baseURL = baseURL
        self.session = session
        self.requiredFields = requiredFields
    }
    
    nonisolated func fetch<T: Decodable>(endpoint: String) async throws -> T {
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + [
            URLQueryItem(name: "fields", value: requiredFields)
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

