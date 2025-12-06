//
//  HomeView.swift
//  CampusMenuIOS
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var selectedCategory: MenuCategory? = nil
    @State private var selectedMenuItem: MenuItem? = nil
    @State private var showReviewDialog = false
    
    var todaysMenu: MenuDay? {
        let today = Calendar.current.startOfDay(for: Date())
        return repository.menuHistory.first { menu in
            Calendar.current.isDate(menu.date, inSameDayAs: today)
        }
    }
    
    var filteredItems: [MenuItem] {
        guard let menu = todaysMenu else { return [] }
        if let category = selectedCategory {
            return menu.items.filter { $0.category == category }
        }
        return menu.items
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with date
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Günün Menüsü")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                        
                        Text(Date(), style: .date)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
            }
            
            // Category filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryButton(
                        title: "Tümü",
                        isSelected: selectedCategory == nil,
                        color: .orange
                    ) {
                        selectedCategory = nil
                    }
                    
                    CategoryButton(
                        title: "Kapalı",
                        icon: "🔒",
                        isSelected: false,
                        color: .red
                    ) { }
                    
                    CategoryButton(
                        title: "Tatil",
                        icon: "🗓️",
                        isSelected: false,
                        color: .orange
                    ) { }
                    
                    ForEach(MenuCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: localization.localized(category.localizedKey),
                            isSelected: selectedCategory == category,
                            color: .orange
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            
            // Menu items
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredItems) { item in
                        MenuItemCard(
                            item: item,
                            isFavorite: repository.currentStudent?.favoriteMenuItems.contains(item.id) ?? false,
                            onFavoriteToggle: {
                                toggleFavorite(item)
                            },
                            onRate: {
                                selectedMenuItem = item
                                showReviewDialog = true
                            }
                        )
                    }
                }
                .padding()
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        }
        .sheet(item: $selectedMenuItem) { item in
            ReviewDialog(menuItem: item)
        }
    }
    
    private func toggleFavorite(_ item: MenuItem) {
        guard var student = repository.currentStudent else { return }
        
        if let index = student.favoriteMenuItems.firstIndex(of: item.id) {
            student.favoriteMenuItems.remove(at: index)
        } else {
            student.favoriteMenuItems.append(item.id)
        }
        
        repository.updateStudent(student)
    }
}

struct CategoryButton: View {
    let title: String
    var icon: String = ""
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if !icon.isEmpty {
                    Text(icon)
                        .font(.system(size: 16))
                }
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color.white)
            .foregroundColor(isSelected ? .white : Color(red: 0.2, green: 0.27, blue: 0.31))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
