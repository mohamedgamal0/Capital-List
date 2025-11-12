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
    private var searchTask: Task<Void, Never>?
    
    init(searchUseCase: SearchCountryUseCase) {
        self.searchUseCase = searchUseCase
    }
    
    func search() {
        AppLogger.info("Search triggered with query: '\(searchText)'")
        searchTask?.cancel()
        
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            AppLogger.debug("Empty search query, clearing results")
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                AppLogger.debug("Executing search for: '\(searchText)'")
                let results = try await searchUseCase.execute(query: searchText)
                if !Task.isCancelled {
                    searchResults = results
                    isLoading = false
                    AppLogger.success("Search completed: \(results.count) results")
                } else {
                    AppLogger.debug("Search was cancelled")
                }
            } catch {
                if !Task.isCancelled {
                    AppLogger.error("Search error: \(error.localizedDescription)")
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

