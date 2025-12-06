//
//  CategoryChip.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct CategoryChip: View {
    let category: MenuCategory?
    let isSelected: Bool
    let onTap: () -> Void
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                if let cat = category {
                    Text(cat.icon)
                        .font(.caption)
                } else {
                    Image(systemName: "square.grid.2x2")
                        .font(.caption)
                }
                
                Text(localization.localized(category?.localizedKey ?? "all"))
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? themeManager.currentTheme.primary : Color.adaptiveSurface(themeManager.isDarkMode))
            .foregroundColor(isSelected ? .white : Color.adaptiveText(themeManager.isDarkMode))
            .cornerRadius(20)
        }
    }
}
