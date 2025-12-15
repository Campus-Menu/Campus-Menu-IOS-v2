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
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label("Takvim", systemImage: "calendar")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoriler", systemImage: "heart.fill")
                }
            
            AnnouncementsView()
                .tabItem {
                    Label("Duyurular", systemImage: "megaphone.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .accentColor(themeManager.currentTheme.primary)
    }
}

#Preview {
    ContentView()
}

