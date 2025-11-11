//
//  ContentView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: CountriesViewModel
    
    init() {
        _viewModel = State(initialValue: DependencyContainer.shared.makeCountriesViewModel())
    }
    
    var body: some View {
        CountriesListView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
