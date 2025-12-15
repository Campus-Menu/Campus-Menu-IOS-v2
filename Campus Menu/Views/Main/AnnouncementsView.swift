//
//  AnnouncementsView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct AnnouncementsView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var sortedAnnouncements: [Announcement] {
        repository.announcements.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                if sortedAnnouncements.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "megaphone")
                            .font(.system(size: 60))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        
                        Text(localization.localized("no_announcements"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedAnnouncements) { announcement in
                                AnnouncementCard(announcement: announcement)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Duyurular")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct AnnouncementCard: View {
    let announcement: Announcement
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var typeColor: Color {
        switch announcement.type {
        case .maintenance: return .orange
        case .event: return .blue
        case .menuChange: return .green
        case .general: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Text(announcement.type.icon)
                        .font(.title3)
                    Text(localization.localized(announcement.type.localizedKey))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(typeColor.opacity(0.2))
                .foregroundColor(typeColor)
                .cornerRadius(8)
                
                Spacer()
                
                Text(announcement.date, style: .date)
                    .font(.caption)
                    .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
            }
            
            Text(announcement.title)
                .font(.headline)
                .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
            
            Text(announcement.content)
                .font(.subheadline)
                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                .lineLimit(nil)
        }
        .padding()
        .background(Color.adaptiveCard(themeManager.isDarkMode))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}
