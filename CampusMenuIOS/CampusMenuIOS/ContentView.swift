//
//  ContentView.swift
//  Campus Menu
//
//  Created by Çağan Şahbaz on 6.12.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var repository = DataRepository.shared
    
    @State private var isLoggedIn = false
    @State private var selectedRole: UserRole? = nil
    @State private var showRegister = false
    
    var body: some View {
        Group {
            if !isLoggedIn {
                // Auth flow
                if selectedRole == nil {
                    RoleSelectionView(selectedRole: $selectedRole)
                } else if selectedRole == .admin {
                    AdminLoginView(isLoggedIn: $isLoggedIn, selectedRole: $selectedRole)
                } else {
                    if showRegister {
                        StudentRegisterView(isPresented: $showRegister, isLoggedIn: $isLoggedIn)
                    } else {
                        StudentLoginView(isLoggedIn: $isLoggedIn, selectedRole: $selectedRole, showRegister: $showRegister)
                    }
                }
            } else {
                // Main app
                if repository.currentUser?.role == .admin {
                    AdminTabView(isLoggedIn: $isLoggedIn)
                } else {
                    StudentTabView(isLoggedIn: $isLoggedIn)
                }
            }
        }
        .onAppear {
            // Check if already logged in
            if repository.currentUser != nil {
                isLoggedIn = true
            }
        }
    }
}

// MARK: - Student Tab View

struct StudentTabView: View {
    @Binding var isLoggedIn: Bool
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(localization.localized("home"), systemImage: "house.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label(localization.localized("calendar"), systemImage: "calendar")
                }
            
            FavoritesView()
                .tabItem {
                    Label(localization.localized("favorites"), systemImage: "heart.fill")
                }
            
            AnnouncementsView()
                .tabItem {
                    Label(localization.localized("announcements"), systemImage: "megaphone.fill")
                }
            
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label(localization.localized("profile"), systemImage: "person.fill")
                }
        }
        .accentColor(themeManager.currentTheme.primary)
    }
}

// MARK: - Admin Tab View

struct AdminTabView: View {
    @Binding var isLoggedIn: Bool
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(localization.localized("home"), systemImage: "house.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label(localization.localized("calendar"), systemImage: "calendar")
                }
            
            AdminManagementView()
                .tabItem {
                    Label(localization.localized("management"), systemImage: "square.and.pencil")
                }
            
            AdminReviewsView()
                .tabItem {
                    Label(localization.localized("reviews"), systemImage: "star.bubble")
                }
            
            AnnouncementsView()
                .tabItem {
                    Label(localization.localized("announcements"), systemImage: "megaphone.fill")
                }
            
            AdminProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label(localization.localized("profile"), systemImage: "person.fill")
                }
        }
        .accentColor(themeManager.currentTheme.primary)
    }
}

// MARK: - Admin Profile View

struct AdminProfileView: View {
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
                                    Image(systemName: "person.badge.key.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                            
                            Text(localization.localized("admin"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                            
                            Text(repository.currentUser?.email ?? "")
                                .font(.subheadline)
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
                AdminSettingsView()
            }
        }
    }
}

// MARK: - Admin Settings View

struct AdminSettingsView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
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
        }
    }
}

