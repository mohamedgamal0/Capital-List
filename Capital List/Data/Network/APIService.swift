//
//  APIService.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error with code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

actor APIService {
    private let baseURL = "https://restcountries.com/v3.1"
    private let session: URLSession
    
    // Required fields for v3.1 API
    private let requiredFields = "name,capital,currencies,cca2"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: String) async throws -> T {
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

