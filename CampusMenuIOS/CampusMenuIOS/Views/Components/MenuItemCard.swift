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
    
    var backgroundColor: Color {
        switch item.category {
        case .breakfast:
            return Color(red: 1.0, green: 0.95, blue: 0.9)
        case .lunch:
            return Color(red: 1.0, green: 0.93, blue: 0.8)
        case .dinner:
            return Color(red: 1.0, green: 0.87, blue: 0.73)
        case .snack:
            return Color(red: 1.0, green: 0.98, blue: 0.8)
        case .soup:
            return Color(red: 1.0, green: 0.93, blue: 0.93)
        case .dessert:
            return Color(red: 0.97, green: 0.9, blue: 1.0)
        }
    }
    
    var categoryColor: Color {
        switch item.category {
        case .breakfast:
            return Color.orange
        case .lunch:
            return Color.orange.opacity(0.8)
        case .dinner:
            return Color.orange.opacity(0.9)
        case .snack:
            return Color.yellow.opacity(0.9)
        case .soup:
            return Color.red.opacity(0.7)
        case .dessert:
            return Color.purple.opacity(0.7)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area with emoji and calorie badge
            ZStack(alignment: .topTrailing) {
                backgroundColor
                    .frame(height: 180)
                
                // Large emoji in center
                Text(item.category.icon)
                    .font(.system(size: 80))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Calorie badge
                Text("k/\(item.calories)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(categoryColor)
                    .cornerRadius(20)
                    .padding(12)
            }
            
            // Content area
            VStack(alignment: .leading, spacing: 8) {
                // Title and favorite
                HStack {
                    Text(item.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                    
                    Spacer()
                    
                    Button(action: onFavoriteToggle) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .font(.system(size: 20))
                    }
                }
                
                // Rating
                HStack(spacing: 4) {
                    if item.rating > 0 {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                        Text(String(format: "%.1f", item.rating))
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        Text("Henüz değerlendirme yok")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Calorie info
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                        Text("\(item.calories) kcal")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .onTapGesture {
            onRate()
        }
    }
}
