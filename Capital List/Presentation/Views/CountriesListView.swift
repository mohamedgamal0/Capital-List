//
//  CountriesListView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI

struct CountriesListView: View {
    @State private var viewModel: CountriesViewModel
    @State private var showingSearch = false
    
    init(viewModel: CountriesViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? DependencyContainer.shared.makeCountriesViewModel())
    }
    
    // Helper to ensure view updates when favoriteCountries changes
    private var countriesCount: Int {
        viewModel.favoriteCountries.count
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.favoriteCountries.isEmpty {
                    VStack(spacing: AppSpacing.md) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(AppColors.primary)
                        Text("Loading countries...")
                            .font(AppTypography.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else if viewModel.favoriteCountries.isEmpty {
                    EmptyStateView(
                        icon: "globe.americas.fill",
                        title: "No Countries Added",
                        message: "Start by adding your first country. Tap the + button to search and add countries to your list.",
                        actionTitle: "Add Country",
                        action: { showingSearch = true }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.md) {
                            // Header Info
                            HStack {
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text("My Countries")
                                        .font(AppTypography.title2)
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("\(viewModel.favoriteCountries.count) of 5 countries")
                                        .font(AppTypography.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.top, AppSpacing.md)
                            
                            ForEach(viewModel.favoriteCountries) { country in
                                CountryRowView(
                                    country: country,
                                    onRemove: {
                                        Task {
                                            await viewModel.removeFavoriteCountry(country)
                                        }
                                    },
                                    onTap: {
                                        // Navigation will be handled separately if needed
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.bottom, AppSpacing.lg)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CompactThemeToggle()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSearch = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: viewModel.canAddMore ? [AppColors.primary, AppColors.accent] : [Color.gray, Color.gray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .disabled(!viewModel.canAddMore)
                    .opacity(viewModel.canAddMore ? 1.0 : 0.5)
                }
            }
            .sheet(isPresented: $showingSearch) {
                SearchView(
                    onCountrySelected: { country in
                        Task {
                            await viewModel.addFavoriteCountry(country)
                            showingSearch = false
                        }
                    },
                    canAddMore: viewModel.canAddMore
                )
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
            .task {
                await viewModel.loadFavoriteCountries()
                if viewModel.favoriteCountries.isEmpty {
                    await viewModel.loadInitialCountry()
                }
            }
        }
    }
}

struct CountryRowView: View {
    let country: Country
    let onRemove: () -> Void
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: CountryDetailView(country: country)) {
                CardView(
                    cornerRadius: AppCornerRadius.medium,
                    shadow: AppShadows.small,
                    backgroundColor: AppColors.cardBackground
                ) {
                    HStack(spacing: AppSpacing.md) {
                        // Country Flag/Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AppColors.primary.opacity(0.2), AppColors.accent.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "flag.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColors.primary, AppColors.accent],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        // Country Info
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text(country.countryName)
                                .font(AppTypography.title3)
                                .foregroundColor(AppColors.textPrimary)
                            
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                IconLabel(
                                    icon: "building.2.fill",
                                    text: country.capitalDisplay,
                                    iconColor: AppColors.primary,
                                    textColor: AppColors.textSecondary
                                )
                                
                                IconLabel(
                                    icon: "dollarsign.circle.fill",
                                    text: country.currencyDisplay,
                                    iconColor: AppColors.accent,
                                    textColor: AppColors.textSecondary
                                )
                            }
                        }
                        
                        Spacer()
                        
                        // Spacer for button area
                        Color.clear
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Remove Button - Overlay on top to prevent NavigationLink interference
            HStack {
                Spacer()
                Button {
                    Task { @MainActor in
                        onRemove()
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.error)
                        .frame(width: 40, height: 40)
                        .background(AppColors.error.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, AppSpacing.md)
            }
            .allowsHitTesting(true)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(AppAnimations.quick, value: isPressed)
    }
}


#Preview {
    CountriesListView(viewModel: DependencyContainer.shared.makeCountriesViewModel())
}

