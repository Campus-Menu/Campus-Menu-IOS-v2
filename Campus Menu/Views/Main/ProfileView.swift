//
//  ProfileView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile header
                        VStack(spacing: 12) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [themeManager.currentTheme.primary, themeManager.currentTheme.secondary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text(repository.currentStudent?.name.prefix(1).uppercased() ?? "S")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            Text(repository.currentStudent?.name ?? "")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                            
                            Text(repository.currentStudent?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            
                            Text(repository.currentStudent?.studentNumber ?? "")
                                .font(.caption)
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        }
                        .padding(.top, 20)
                        
                        // Menu sections
                        VStack(spacing: 12) {
                            ProfileMenuItem(
                                icon: "gearshape.fill",
                                title: localization.localized("settings"),
                                action: { showSettings = true }
                            )
                            
                            ProfileMenuItem(
                                icon: "arrow.right.square.fill",
                                title: localization.localized("logout"),
                                isDestructive: true,
                                action: {
                                    repository.logout()
                                    isLoggedIn = false
                                }
                            )
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(localization.localized("my_profile"))
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isDestructive ? .red : themeManager.currentTheme.primary)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(isDestructive ? .red : Color.adaptiveText(themeManager.isDarkMode))
                
                Spacer()
                
                if !isDestructive {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.adaptiveCard(themeManager.isDarkMode))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedAllergens: Set<Allergen> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                Form {
                    // Theme Section
                    Section(header: Text(localization.localized("theme"))) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                themeManager.setTheme(theme)
                            }) {
                                HStack {
                                    Circle()
                                        .fill(theme.primary)
                                        .frame(width: 24, height: 24)
                                    
                                    Text(localization.localized(theme.localizedKey))
                                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                                    
                                    Spacer()
                                    
                                    if themeManager.currentTheme == theme {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(theme.primary)
                                    }
                                }
                            }
                        }
                        
                        Toggle(localization.localized("dark_mode"), isOn: Binding(
                            get: { themeManager.isDarkMode },
                            set: { _ in themeManager.toggleDarkMode() }
                        ))
                    }
                    
                    // Language Section
                    Section(header: Text(localization.localized("language"))) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Button(action: {
                                localization.setLanguage(language)
                            }) {
                                HStack {
                                    Text(language.flag)
                                        .font(.title3)
                                    
                                    Text(language.displayName)
                                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                                    
                                    Spacer()
                                    
                                    if localization.currentLanguage == language {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(themeManager.currentTheme.primary)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Notifications Section
                    Section(header: Text(localization.localized("notifications"))) {
                        Toggle(localization.localized("menu_updates"), isOn: Binding(
                            get: { repository.preferences.notificationSettings.menuUpdates },
                            set: { value in
                                var prefs = repository.preferences
                                prefs.notificationSettings.menuUpdates = value
                                repository.updatePreferences(prefs)
                            }
                        ))
                        
                        Toggle(localization.localized("announcements_notify"), isOn: Binding(
                            get: { repository.preferences.notificationSettings.announcements },
                            set: { value in
                                var prefs = repository.preferences
                                prefs.notificationSettings.announcements = value
                                repository.updatePreferences(prefs)
                            }
                        ))
                    }
                    
                    // Allergies Section
                    Section(header: Text(localization.localized("allergies"))) {
                        ForEach(Allergen.allCases, id: \.self) { allergen in
                            Button(action: {
                                toggleAllergen(allergen)
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
            .navigationTitle(localization.localized("settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localization.localized("close")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
            }
            .onAppear {
                if let student = repository.currentStudent {
                    selectedAllergens = Set(student.allergens)
                }
            }
        }
    }
    
    private func toggleAllergen(_ allergen: Allergen) {
        if selectedAllergens.contains(allergen) {
            selectedAllergens.remove(allergen)
        } else {
            selectedAllergens.insert(allergen)
        }
        
        guard var student = repository.currentStudent else { return }
        student.allergens = Array(selectedAllergens)
        repository.updateStudent(student)
    }
}
