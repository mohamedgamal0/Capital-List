//
//  ContentView.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    CountriesListView()
                } label: {
                    CardView {
                        IconLabel(
                            icon: "globe",
                            text: "Countries",
                            iconColor: AppColors.primary,
                            textColor: AppColors.textPrimary,
                            fontSize: AppTypography.body
                        )
                    }
                }
                .listRowInsets(EdgeInsets(top: AppSpacing.xs, leading: AppSpacing.md, bottom: AppSpacing.xs, trailing: AppSpacing.md))
                .listRowBackground(Color.clear)
                
                ForEach(items) { item in
                    NavigationLink {
                        CardView(padding: AppSpacing.lg) {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                IconLabel(
                                    icon: "clock",
                                    text: "Item Details",
                                    iconColor: AppColors.primary,
                                    textColor: AppColors.textPrimary,
                                    fontSize: AppTypography.title3
                                )
                                
                                Divider()
                                    .background(AppColors.textTertiary)
                                
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    IconLabel(
                                        icon: "calendar",
                                        text: item.timestamp.formatted(date: .complete, time: .standard),
                                        iconColor: AppColors.textSecondary,
                                        textColor: AppColors.textPrimary,
                                        fontSize: AppTypography.body
                                    )
                                    
                                    IconLabel(
                                        icon: "clock.arrow.circlepath",
                                        text: item.timestamp.formatted(.relative(presentation: .named)),
                                        iconColor: AppColors.textSecondary,
                                        textColor: AppColors.textSecondary,
                                        fontSize: AppTypography.caption
                                    )
                                }
                            }
                        }
                    } label: {
                        CardView {
                            IconLabel(
                                icon: "list.bullet",
                                text: item.timestamp.formatted(date: .numeric, time: .standard),
                                iconColor: AppColors.primary,
                                textColor: AppColors.textPrimary,
                                fontSize: AppTypography.body
                            )
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: AppSpacing.xs, leading: AppSpacing.md, bottom: AppSpacing.xs, trailing: AppSpacing.md))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .background(AppColors.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Capital List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .foregroundColor(AppColors.primary)
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                            .foregroundColor(AppColors.primary)
                    }
                }
            }
        } detail: {
            CardView(padding: AppSpacing.xl) {
                VStack(spacing: AppSpacing.md) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Select an item")
                        .font(AppTypography.title3)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
        }
    }

    private func addItem() {
        withAnimation(AppAnimations.standard) {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation(AppAnimations.standard) {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
