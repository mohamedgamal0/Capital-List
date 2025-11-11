//
//  SearchView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    let onCountrySelected: (Country) -> Void
    let canAddMore: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        onCountrySelected: @escaping (Country) -> Void,
        canAddMore: Bool
    ) {
        self.onCountrySelected = onCountrySelected
        self.canAddMore = canAddMore
        _viewModel = State(initialValue: DependencyContainer.shared.makeSearchViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [AppColors.background, AppColors.secondaryBackground],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Warning Banner
                    if !canAddMore {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(AppColors.warning)
                            Text("You can only add up to 5 countries")
                                .font(AppTypography.subheadline)
                                .foregroundColor(AppColors.warning)
                        }
                        .padding(AppSpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.warning.opacity(0.15))
                    }
                    
                    // Search Bar
                    SearchBar(text: $viewModel.searchText, onSearchButtonClicked: {
                        viewModel.search()
                    })
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.md)
                    
                    // Content
                    if viewModel.isLoading {
                        Spacer()
                        VStack(spacing: AppSpacing.md) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(AppColors.primary)
                            Text("Searching...")
                                .font(AppTypography.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                    } else if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                        Spacer()
                        EmptyStateView(
                            icon: "magnifyingglass",
                            title: "No Results",
                            message: "No countries found matching '\(viewModel.searchText)'. Try a different search term."
                        )
                        Spacer()
                    } else if viewModel.searchResults.isEmpty {
                        Spacer()
                        EmptyStateView(
                            icon: "magnifyingglass",
                            title: "Search Countries",
                            message: "Start typing to search for countries by name, capital, or currency."
                        )
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.searchResults) { country in
                                    Button(action: {
                                        onCountrySelected(country)
                                        dismiss()
                                    }) {
                                        CountrySearchRowView(country: country)
                                    }
                                    .disabled(!canAddMore)
                                    .opacity(canAddMore ? 1.0 : 0.5)
                                }
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.bottom, AppSpacing.lg)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primary)
                    .font(AppTypography.bodyBold)
                }
            }
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.search()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSearchButtonClicked: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search countries...", text: $text)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)
                .focused($isFocused)
                .onSubmit {
                    onSearchButtonClicked()
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .stroke(isFocused ? AppColors.primary : Color.clear, lineWidth: 2)
        )
        .shadow(color: AppShadows.small.color, radius: AppShadows.small.radius, x: AppShadows.small.x, y: AppShadows.small.y)
    }
}

struct CountrySearchRowView: View {
    let country: Country
    
    var body: some View {
        CardView(
            cornerRadius: AppCornerRadius.medium,
            shadow: AppShadows.small,
            backgroundColor: AppColors.cardBackground
        ) {
            HStack(spacing: AppSpacing.md) {
                // Flag Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary.opacity(0.2), AppColors.accent.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: "flag.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                // Country Info
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(country.countryName)
                        .font(AppTypography.bodyBold)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if !country.capitalDisplay.isEmpty && country.capitalDisplay != "N/A" {
                        IconLabel(
                            icon: "building.2.fill",
                            text: country.capitalDisplay,
                            iconColor: AppColors.primary,
                            textColor: AppColors.textSecondary,
                            fontSize: AppTypography.caption
                        )
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textTertiary)
            }
        }
    }
}

#Preview {
    SearchView(
        onCountrySelected: { _ in },
        canAddMore: true
    )
}

