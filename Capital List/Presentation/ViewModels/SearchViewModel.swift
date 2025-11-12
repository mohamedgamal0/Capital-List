//
//  SearchViewModel.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class SearchViewModel {
    var searchText = ""
    var searchResults: [Country] = []
    var isLoading = false
    var errorMessage: String?
    
    private let searchUseCase: SearchCountryUseCase
    private let logger: LoggerProtocol
    private var searchTask: Task<Void, Never>?
    
    init(
        searchUseCase: SearchCountryUseCase,
        logger: LoggerProtocol
    ) {
        self.searchUseCase = searchUseCase
        self.logger = logger
    }
    
    func search() {
        logger.info("Search triggered with query: '\(searchText)'")
        searchTask?.cancel()
        
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            logger.debug("Empty search query, clearing results")
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                logger.debug("Executing search for: '\(searchText)'")
                let results = try await searchUseCase.execute(query: searchText)
                if !Task.isCancelled {
                    searchResults = results
                    isLoading = false
                    logger.success("Search completed: \(results.count) results")
                } else {
                    logger.debug("Search was cancelled")
                }
            } catch {
                if !Task.isCancelled {
                    logger.error("Search error: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchText = ""
        searchResults = []
        errorMessage = nil
    }
}

