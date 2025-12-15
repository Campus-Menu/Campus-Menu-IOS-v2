//
//  ContentView.swift
//  Campus Menu
//
//  Created by Çağan Şahbaz on 6.12.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var repository = DataRepository.shared
    
    var body: some View {
        // Direkt öğrenci görünümüne git - Giriş yok!
        StudentTabView()
            .onAppear {
                // Eğer currentStudent yoksa, default student oluştur
                if repository.currentStudent == nil {
                    if let firstStudent = repository.students.first {
                        repository.currentStudent = firstStudent
                    }
                }
            }
    }
}

// MARK: - Student Tab View

struct StudentTabView: View {
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
            
            ProfileView()
                .tabItem {
                    Label(localization.localized("profile"), systemImage: "person.fill")
                }
        }
        .accentColor(themeManager.currentTheme.primary)
    }
}

#Preview {
    ContentView()
}

