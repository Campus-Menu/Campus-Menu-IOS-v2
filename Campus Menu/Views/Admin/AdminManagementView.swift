//
//  AdminManagementView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct AdminManagementView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var showAddMenu = false
    @State private var selectedMenu: MenuDay? = nil
    
    var sortedMenus: [MenuDay] {
        repository.menuHistory.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                if sortedMenus.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        
                        Text(localization.localized("no_menus"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedMenus) { menu in
                                AdminMenuCard(menu: menu) {
                                    selectedMenu = menu
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(localization.localized("menu_management"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddMenu = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(themeManager.currentTheme.primary)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddMenu) {
                AddMenuView()
            }
            .sheet(item: $selectedMenu) { menu in
                EditMenuView(menu: menu)
            }
        }
    }
}

struct AdminMenuCard: View {
    let menu: MenuDay
    let onEdit: () -> Void
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var showDeleteConfirm = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(menu.date, style: .date)
                        .font(.headline)
                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                    
                    Text("\(menu.items.count) \(localization.localized("menu_items"))")
                        .font(.caption)
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                }
                
                Spacer()
                
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Button(action: { showDeleteConfirm = true }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
            
            // Category breakdown
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MenuCategory.allCases, id: \.self) { category in
                        let count = menu.items.filter { $0.category == category }.count
                        if count > 0 {
                            HStack(spacing: 4) {
                                Text(category.icon)
                                Text("\(count)")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(themeManager.currentTheme.primary.opacity(0.2))
                            .foregroundColor(themeManager.currentTheme.primary)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.adaptiveCard(themeManager.isDarkMode))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
        .alert(localization.localized("confirm_delete"), isPresented: $showDeleteConfirm) {
            Button(localization.localized("cancel"), role: .cancel) {}
            Button(localization.localized("delete"), role: .destructive) {
                repository.deleteMenuDay(menu.id)
            }
        }
    }
}

// MARK: - Add Menu View

struct AddMenuView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate = Date()
    @State private var menuItems: [MenuItem] = []
    @State private var showAddItem = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text(localization.localized("menu_date"))) {
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    }
                    
                    Section(header: Text(localization.localized("menu_items"))) {
                        ForEach(menuItems) { item in
                            HStack {
                                Text(item.category.icon)
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.subheadline)
                                    Text("\(item.calories) kcal")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            menuItems.remove(atOffsets: indexSet)
                        }
                        
                        Button(action: { showAddItem = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(themeManager.currentTheme.primary)
                                Text(localization.localized("add_item"))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(localization.localized("add_menu_day"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.localized("save")) {
                        saveMenu()
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                    .disabled(menuItems.isEmpty)
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddMenuItemView { item in
                    menuItems.append(item)
                }
            }
        }
    }
    
    private func saveMenu() {
        let newMenu = MenuDay(
            id: UUID().uuidString,
            date: Calendar.current.startOfDay(for: selectedDate),
            items: menuItems
        )
        repository.addMenuDay(newMenu)
    }
}

// MARK: - Edit Menu View

struct EditMenuView: View {
    let menu: MenuDay
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var menuItems: [MenuItem] = []
    @State private var showAddItem = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text(localization.localized("menu_date"))) {
                        Text(menu.date, style: .date)
                            .font(.headline)
                    }
                    
                    Section(header: Text(localization.localized("menu_items"))) {
                        ForEach(menuItems) { item in
                            HStack {
                                Text(item.category.icon)
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.subheadline)
                                    Text("\(item.calories) kcal")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            menuItems.remove(atOffsets: indexSet)
                        }
                        
                        Button(action: { showAddItem = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(themeManager.currentTheme.primary)
                                Text(localization.localized("add_item"))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(localization.localized("edit_menu"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.localized("save")) {
                        saveChanges()
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddMenuItemView { item in
                    menuItems.append(item)
                }
            }
            .onAppear {
                menuItems = menu.items
            }
        }
    }
    
    private func saveChanges() {
        var updatedMenu = menu
        updatedMenu.items = menuItems
        repository.updateMenuDay(updatedMenu)
    }
}

// MARK: - Add Menu Item View

struct AddMenuItemView: View {
    let onAdd: (MenuItem) -> Void
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var category: MenuCategory = .lunch
    @State private var calories = ""
    @State private var description = ""
    @State private var selectedAllergens: Set<Allergen> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        TextField(localization.localized("item_name"), text: $name)
                        
                        Picker(localization.localized("category"), selection: $category) {
                            ForEach(MenuCategory.allCases, id: \.self) { cat in
                                HStack {
                                    Text(cat.icon)
                                    Text(localization.localized(cat.localizedKey))
                                }
                                .tag(cat)
                            }
                        }
                        
                        TextField(localization.localized("calories"), text: $calories)
                            .keyboardType(.numberPad)
                        
                        TextField("\(localization.localized("description")) \(localization.localized("optional"))", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    
                    Section(header: Text(localization.localized("allergens"))) {
                        ForEach(Allergen.allCases, id: \.self) { allergen in
                            Button(action: {
                                if selectedAllergens.contains(allergen) {
                                    selectedAllergens.remove(allergen)
                                } else {
                                    selectedAllergens.insert(allergen)
                                }
                            }) {
                                HStack {
                                    Text(allergen.icon)
                                    Text(localization.localized(allergen.localizedKey))
                                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                                    
                                    Spacer()
                                    
                                    if selectedAllergens.contains(allergen) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(themeManager.currentTheme.primary)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(localization.localized("add_item"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.localized("save")) {
                        if !name.isEmpty, let cal = Int(calories) {
                            let newItem = MenuItem(
                                name: name,
                                description: description.isEmpty ? nil : description,
                                category: category,
                                calories: cal,
                                allergens: Array(selectedAllergens)
                            )
                            onAdd(newItem)
                            dismiss()
                        }
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                    .disabled(name.isEmpty || calories.isEmpty)
                }
            }
        }
    }
}
