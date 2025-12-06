//
//  MenuItemCard.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct MenuItemCard: View {
    let item: MenuItem
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    let onRate: () -> Void
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with favorite button
            HStack {
                HStack(spacing: 6) {
                    Text(item.category.icon)
                        .font(.title3)
                    
                    Text(localization.localized(item.category.localizedKey))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.currentTheme.primary)
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        .font(.title3)
                }
            }
            
            // Item name
            Text(item.name)
                .font(.headline)
                .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
            
            // Description
            if let description = item.description, !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    .lineLimit(2)
            }
            
            // Allergens
            if !item.allergens.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(item.allergens, id: \.self) { allergen in
                            HStack(spacing: 2) {
                                Text(allergen.icon)
                                    .font(.caption2)
                                Text(localization.localized(allergen.localizedKey))
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(4)
                        }
                    }
                }
            }
            
            Divider()
            
            // Footer with calories and rating
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("\(item.calories) \(localization.localized("kcal"))")
                        .font(.caption)
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                }
                
                Spacer()
                
                Button(action: onRate) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", item.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("(\(item.reviewCount))")
                            .font(.caption)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                }
            }
        }
        .padding(12)
        .background(Color.adaptiveCard(themeManager.isDarkMode))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}
