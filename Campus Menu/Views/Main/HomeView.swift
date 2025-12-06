//
//  HomeView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var selectedCategory: MenuCategory? = nil
    @State private var showReviewDialog = false
    @State private var selectedMenuItem: MenuItem? = nil
    @State private var showReviewsList = false
    
    var todaysMenu: MenuDay? {
        let today = Calendar.current.startOfDay(for: Date())
        return repository.menuHistory.first { menu in
            Calendar.current.isDate(menu.date, inSameDayAs: today)
        }
    }
    
    var filteredMenuItems: [MenuItem] {
        guard let menu = todaysMenu else { return [] }
        
        var items = menu.items
        
        // Filter by category
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        
        // Filter by student allergens
        if let student = repository.currentStudent {
            items = items.filter { item in
                let hasCommonAllergen = !Set(item.allergens).isDisjoint(with: Set(student.allergens))
                return !hasCommonAllergen
            }
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                if todaysMenu == nil {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        
                        Text(localization.localized("no_menu_today"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Category filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CategoryChip(
                                        category: nil,
                                        isSelected: selectedCategory == nil,
                                        onTap: { selectedCategory = nil }
                                    )
                                    
                                    ForEach(MenuCategory.allCases, id: \.self) { category in
                                        CategoryChip(
                                            category: category,
                                            isSelected: selectedCategory == category,
                                            onTap: { selectedCategory = category }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 8)
                            
                            // Menu items grid
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 12) {
                                ForEach(filteredMenuItems) { item in
                                    MenuItemCard(
                                        item: item,
                                        isFavorite: repository.currentStudent?.favoriteMenuItems.contains(item.id) ?? false,
                                        onFavoriteToggle: {
                                            toggleFavorite(item)
                                        },
                                        onRate: {
                                            selectedMenuItem = item
                                            showReviewsList = true
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle(localization.localized("todays_menu"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if let item = filteredMenuItems.first {
                            selectedMenuItem = item
                            showReviewDialog = true
                        }
                    }) {
                        Image(systemName: "star.bubble")
                            .foregroundColor(themeManager.currentTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $showReviewDialog) {
                if let item = selectedMenuItem {
                    ReviewDialog(menuItem: item)
                }
            }
            .sheet(isPresented: $showReviewsList) {
                if let item = selectedMenuItem {
                    ReviewsListView(menuItem: item)
                }
            }
        }
    }
    
    private func toggleFavorite(_ item: MenuItem) {
        guard var student = repository.currentStudent else { return }
        
        if student.favoriteMenuItems.contains(item.id) {
            student.favoriteMenuItems.removeAll { $0 == item.id }
        } else {
            student.favoriteMenuItems.append(item.id)
        }
        
        repository.updateStudent(student)
    }
}

// MARK: - Reviews List View

struct ReviewsListView: View {
    let menuItem: MenuItem
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    var reviews: [Review] {
        repository.reviews
            .filter { $0.menuItemId == menuItem.id && $0.isApproved }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                if reviews.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        
                        Text(localization.localized("no_reviews"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(reviews) { review in
                                ReviewCard(review: review)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("\(menuItem.name) - \(localization.localized("reviews_count"))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.localized("close")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
            }
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.studentName)
                    .font(.headline)
                    .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(star <= review.rating ? .yellow : Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                }
            }
            
            Text(review.date, style: .date)
                .font(.caption)
                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
            
            if let comment = review.comment {
                Text(comment)
                    .font(.subheadline)
                    .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
            }
            
            if let response = review.adminResponse {
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localization.localized("admin_response"))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.currentTheme.primary)
                    
                    Text(response)
                        .font(.subheadline)
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                }
            }
        }
        .padding(12)
        .background(Color.adaptiveCard(themeManager.isDarkMode))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}
