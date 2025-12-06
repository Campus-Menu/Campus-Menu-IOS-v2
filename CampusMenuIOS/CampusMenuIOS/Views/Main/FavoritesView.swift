//
//  FavoritesView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var favoriteItems: [MenuItem] {
        guard let student = repository.currentStudent else { return [] }
        
        var items: [MenuItem] = []
        for menu in repository.menuHistory {
            for item in menu.items {
                if student.favoriteMenuItems.contains(item.id) && !items.contains(where: { $0.id == item.id }) {
                    items.append(item)
                }
            }
        }
        return items
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                if favoriteItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        
                        Text(localization.localized("no_favorites"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 12) {
                            ForEach(favoriteItems) { item in
                                MenuItemCard(
                                    item: item,
                                    isFavorite: true,
                                    onFavoriteToggle: {
                                        toggleFavorite(item)
                                    },
                                    onRate: {}
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(localization.localized("my_favorites"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func toggleFavorite(_ item: MenuItem) {
        guard var student = repository.currentStudent else { return }
        student.favoriteMenuItems.removeAll { $0 == item.id }
        repository.updateStudent(student)
    }
}
