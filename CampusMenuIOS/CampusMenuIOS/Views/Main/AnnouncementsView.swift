//
//  AnnouncementsView.swift
//  CampusMenuIOS
//

import SwiftUI

struct AnnouncementsView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var selectedFilter: AnnouncementType? = nil
    
    var filteredAnnouncements: [Announcement] {
        let sorted = repository.announcements.sorted { $0.date > $1.date }
        if let filter = selectedFilter {
            return sorted.filter { $0.type == filter }
        }
        return sorted
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Duyurular")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            // Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "Tümü",
                        isSelected: selectedFilter == nil,
                        color: .orange
                    ) {
                        selectedFilter = nil
                    }
                    
                    FilterChip(
                        title: "Kapalı",
                        icon: "🔒",
                        isSelected: selectedFilter == .maintenance,
                        color: .red
                    ) {
                        selectedFilter = .maintenance
                    }
                    
                    FilterChip(
                        title: "Tatil",
                        icon: "🗓️",
                        isSelected: selectedFilter == .event,
                        color: .orange
                    ) {
                        selectedFilter = .event
                    }
                    
                    FilterChip(
                        title: "Bakım",
                        icon: "⚠️",
                        isSelected: false,
                        color: .orange
                    ) { }
                    
                    FilterChip(
                        title: "Genel",
                        icon: "📰",
                        isSelected: selectedFilter == .general,
                        color: .orange
                    ) {
                        selectedFilter = .general
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            
            // Announcements list
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredAnnouncements) { announcement in
                        AnnouncementCard(announcement: announcement)
                    }
                }
                .padding()
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        }
    }
}

struct FilterChip: View {
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
                        .font(.system(size: 14))
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

struct AnnouncementCard: View {
    let announcement: Announcement
    
    var cardColor: Color {
        switch announcement.type {
        case .maintenance:
            return Color(red: 1.0, green: 0.95, blue: 0.95)
        case .event:
            return Color(red: 0.95, green: 0.97, blue: 1.0)
        case .menuChange:
            return Color(red: 1.0, green: 0.97, blue: 0.9)
        case .general:
            return Color(red: 0.95, green: 0.97, blue: 1.0)
        }
    }
    
    var accentColor: Color {
        switch announcement.type {
        case .maintenance:
            return .red
        case .event:
            return .blue
        case .menuChange:
            return .orange
        case .general:
            return .blue
        }
    }
    
    var icon: String {
        switch announcement.type {
        case .maintenance:
            return "🔒"
        case .event:
            return "📅"
        case .menuChange:
            return "🔄"
        case .general:
            return "📢"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with icon and badge
            HStack(spacing: 12) {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(icon)
                            .font(.system(size: 20))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(announcement.type == .maintenance ? "Kapalı" : announcement.type == .event ? "Genel" : "Tatil")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(accentColor)
                            .cornerRadius(12)
                        
                        if announcement.type == .maintenance {
                            Text("ÖNEMLİ")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(cardColor)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(announcement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                
                Text(announcement.content)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(announcement.date, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)
            }
            .padding()
            .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}
