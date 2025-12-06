//
//  CalendarView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var selectedDate: Date = Date()
    
    var selectedMenu: MenuDay? {
        repository.menuHistory.first { menu in
            Calendar.current.isDate(menu.date, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Date picker
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .accentColor(themeManager.currentTheme.primary)
                    .padding()
                    .background(Color.adaptiveCard(themeManager.isDarkMode))
                    
                    Divider()
                    
                    // Menu content
                    if let menu = selectedMenu {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 12) {
                                ForEach(menu.items) { item in
                                    MenuItemCard(
                                        item: item,
                                        isFavorite: repository.currentStudent?.favoriteMenuItems.contains(item.id) ?? false,
                                        onFavoriteToggle: {
                                            toggleFavorite(item)
                                        },
                                        onRate: {}
                                    )
                                }
                            }
                            .padding()
                        }
                    } else {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 60))
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            
                            Text(localization.localized("no_menu_selected"))
                                .font(.headline)
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle(localization.localized("menu_calendar"))
            .navigationBarTitleDisplayMode(.large)
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
