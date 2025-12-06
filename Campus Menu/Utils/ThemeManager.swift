//
//  ThemeManager.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .orange
    @Published var isDarkMode: Bool = false
    
    private let repository = DataRepository.shared
    
    init() {
        loadPreferences()
    }
    
    func loadPreferences() {
        let prefs = repository.preferences
        isDarkMode = prefs.isDarkMode
        currentTheme = AppTheme(rawValue: prefs.theme) ?? .orange
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        var prefs = repository.preferences
        prefs.theme = theme.rawValue
        repository.updatePreferences(prefs)
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        var prefs = repository.preferences
        prefs.isDarkMode = isDarkMode
        repository.updatePreferences(prefs)
    }
}

enum AppTheme: String, CaseIterable {
    case orange
    case blue
    case green
    case purple
    
    var primary: Color {
        switch self {
        case .orange: return Color(hex: "#FF6B35")
        case .blue: return Color(hex: "#2196F3")
        case .green: return Color(hex: "#4CAF50")
        case .purple: return Color(hex: "#9C27B0")
        }
    }
    
    var secondary: Color {
        switch self {
        case .orange: return Color(hex: "#FF8C61")
        case .blue: return Color(hex: "#42A5F5")
        case .green: return Color(hex: "#66BB6A")
        case .purple: return Color(hex: "#AB47BC")
        }
    }
    
    var localizedKey: String {
        return rawValue
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Color Extensions

extension Color {
    static let mintGreen = Color(hex: "#2DD4BF")
    
    // Light theme colors
    static let lightBackground = Color.white
    static let lightSurface = Color(hex: "#F5F5F5")
    static let lightCard = Color.white
    static let lightText = Color.black
    static let lightTextSecondary = Color(hex: "#666666")
    static let lightBorder = Color(hex: "#E0E0E0")
    
    // Dark theme colors
    static let darkBackground = Color(hex: "#121212")
    static let darkSurface = Color(hex: "#1E1E1E")
    static let darkCard = Color(hex: "#2C2C2C")
    static let darkText = Color.white
    static let darkTextSecondary = Color(hex: "#B0B0B0")
    static let darkBorder = Color(hex: "#3E3E3E")
    
    static func adaptiveBackground(_ isDark: Bool) -> Color {
        isDark ? darkBackground : lightBackground
    }
    
    static func adaptiveSurface(_ isDark: Bool) -> Color {
        isDark ? darkSurface : lightSurface
    }
    
    static func adaptiveCard(_ isDark: Bool) -> Color {
        isDark ? darkCard : lightCard
    }
    
    static func adaptiveText(_ isDark: Bool) -> Color {
        isDark ? darkText : lightText
    }
    
    static func adaptiveTextSecondary(_ isDark: Bool) -> Color {
        isDark ? darkTextSecondary : lightTextSecondary
    }
    
    static func adaptiveBorder(_ isDark: Bool) -> Color {
        isDark ? darkBorder : lightBorder
    }
}
