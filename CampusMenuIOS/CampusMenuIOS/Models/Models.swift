//
//  Models.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import Foundation

// MARK: - Enums

enum MenuCategory: String, Codable, CaseIterable {
    case breakfast = "BREAKFAST"
    case lunch = "LUNCH"
    case dinner = "DINNER"
    case snack = "SNACK"
    case soup = "SOUP"
    case dessert = "DESSERT"
    
    var localizedKey: String {
        switch self {
        case .breakfast: return "breakfast"
        case .lunch: return "lunch"
        case .dinner: return "dinner"
        case .snack: return "snack"
        case .soup: return "soup"
        case .dessert: return "dessert"
        }
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "🥐"
        case .lunch: return "🍽️"
        case .dinner: return "🍴"
        case .snack: return "🍪"
        case .soup: return "🍲"
        case .dessert: return "🍰"
        }
    }
}

enum Allergen: String, Codable, CaseIterable {
    case gluten = "GLUTEN"
    case dairy = "DAIRY"
    case eggs = "EGGS"
    case nuts = "NUTS"
    case soy = "SOY"
    case fish = "FISH"
    case shellfish = "SHELLFISH"
    
    var localizedKey: String {
        switch self {
        case .gluten: return "gluten"
        case .dairy: return "dairy"
        case .eggs: return "eggs"
        case .nuts: return "nuts"
        case .soy: return "soy"
        case .fish: return "fish"
        case .shellfish: return "shellfish"
        }
    }
    
    var icon: String {
        switch self {
        case .gluten: return "�"
        case .dairy: return "🥛"
        case .eggs: return "🥚"
        case .nuts: return "🥜"
        case .soy: return "🫘"
        case .fish: return "🐟"
        case .shellfish: return "🦐"
        }
    }
}

enum UserRole: String, Codable {
    case admin = "ADMIN"
    case student = "STUDENT"
}

enum AnnouncementType: String, Codable, CaseIterable {
    case maintenance = "MAINTENANCE"
    case event = "EVENT"
    case menuChange = "MENU_CHANGE"
    case general = "GENERAL"
    
    var localizedKey: String {
        switch self {
        case .maintenance: return "maintenance"
        case .event: return "event"
        case .menuChange: return "menu_change"
        case .general: return "general"
        }
    }
    
    var icon: String {
        switch self {
        case .maintenance: return "🔧"
        case .event: return "�"
        case .menuChange: return "📝"
        case .general: return "📢"
        }
    }
}

// MARK: - Models

struct MenuItem: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String?
    let category: MenuCategory
    let calories: Int
    var rating: Double
    var reviewCount: Int
    let allergens: [Allergen]
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String? = nil,
         category: MenuCategory,
         calories: Int,
         rating: Double = 0.0,
         reviewCount: Int = 0,
         allergens: [Allergen] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.calories = calories
        self.rating = rating
        self.reviewCount = reviewCount
        self.allergens = allergens
    }
}

struct MenuDay: Codable, Identifiable {
    let id: String
    let date: Date
    var items: [MenuItem]
    
    init(id: String = UUID().uuidString, date: Date, items: [MenuItem] = []) {
        self.id = id
        self.date = date
        self.items = items
    }
}

struct Student: Codable, Identifiable {
    let id: String
    var name: String
    let email: String
    let password: String
    let studentNumber: String
    var allergens: [Allergen]
    var favoriteMenuItems: [String]
    
    init(id: String = UUID().uuidString,
         name: String,
         email: String,
         password: String,
         studentNumber: String,
         allergens: [Allergen] = [],
         favoriteMenuItems: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.studentNumber = studentNumber
        self.allergens = allergens
        self.favoriteMenuItems = favoriteMenuItems
    }
}

struct User: Codable, Identifiable {
    let id: String
    let fullName: String
    let email: String
    var role: UserRole
    
    init(id: String = UUID().uuidString,
         fullName: String,
         email: String,
         role: UserRole) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.role = role
    }
}

struct Review: Codable, Identifiable {
    let id: String
    let studentId: String
    let studentName: String
    let menuItemId: String
    let menuItemName: String
    var rating: Int
    var comment: String?
    let date: Date
    var isApproved: Bool
    var adminResponse: String?
    
    init(id: String = UUID().uuidString,
         studentId: String,
         studentName: String,
         menuItemId: String,
         menuItemName: String,
         rating: Int,
         comment: String? = nil,
         date: Date = Date(),
         isApproved: Bool = false,
         adminResponse: String? = nil) {
        self.id = id
        self.studentId = studentId
        self.studentName = studentName
        self.menuItemId = menuItemId
        self.menuItemName = menuItemName
        self.rating = rating
        self.comment = comment
        self.date = date
        self.isApproved = isApproved
        self.adminResponse = adminResponse
    }
}

struct Announcement: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let type: AnnouncementType
    let date: Date
    
    init(id: String = UUID().uuidString,
         title: String,
         content: String,
         type: AnnouncementType,
         date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.date = date
    }
}

struct AppPreferences: Codable {
    var isDarkMode: Bool
    var language: String
    var theme: String
    var notificationSettings: NotificationSettings
    
    init(isDarkMode: Bool = false,
         language: String = "tr",
         theme: String = "orange",
         notificationSettings: NotificationSettings = NotificationSettings()) {
        self.isDarkMode = isDarkMode
        self.language = language
        self.theme = theme
        self.notificationSettings = notificationSettings
    }
}

struct NotificationSettings: Codable {
    var menuUpdates: Bool
    var announcements: Bool
    
    init(menuUpdates: Bool = true,
         announcements: Bool = true) {
        self.menuUpdates = menuUpdates
        self.announcements = announcements
    }
}

    
    var localizedKey: String {
        return rawValue.lowercased()
    }
    
    var icon: String {
        switch self {
        case .gluten: return "🌾"
        case .dairy: return "🥛"
        case .eggs: return "🥚"
        case .nuts: return "🥜"
        case .seafood: return "🦐"
        case .soy: return "🫘"
        case .sesame: return "🌰"
        }
    }
}

enum UserRole: String, Codable {
    case admin = "ADMIN"
    case student = "STUDENT"
}

enum AnnouncementType: String, Codable, CaseIterable {
    case general = "GENERAL"
    case closure = "CLOSURE"
    case holiday = "HOLIDAY"
    case maintenance = "MAINTENANCE"
    
    var localizedKey: String {
        return rawValue.lowercased()
    }
}

// MARK: - Models

struct MenuItem: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let category: MenuCategory
    let calories: Int
    let price: Double
    var rating: Float
    let imageUrl: String?
    var isAvailable: Bool
    let allergens: [Allergen]
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String,
         category: MenuCategory,
         calories: Int,
         price: Double,
         rating: Float = 0,
         imageUrl: String? = nil,
         isAvailable: Bool = true,
         allergens: [Allergen] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.calories = calories
        self.price = price
        self.rating = rating
        self.imageUrl = imageUrl
        self.isAvailable = isAvailable
        self.allergens = allergens
    }
}

struct MenuDay: Codable, Identifiable {
    let id: String
    let date: Date
    var items: [MenuItem]
    
    init(id: String = UUID().uuidString, date: Date, items: [MenuItem] = []) {
        self.id = id
        self.date = date
        self.items = items
    }
}

struct Student: Codable, Identifiable {
    let id: String
    let fullName: String
    let studentNumber: String
    let department: String
    let email: String
    let password: String
    
    init(id: String = UUID().uuidString,
         fullName: String,
         studentNumber: String,
         department: String,
         email: String,
         password: String) {
        self.id = id
        self.fullName = fullName
        self.studentNumber = studentNumber
        self.department = department
        self.email = email
        self.password = password
    }
}

struct User: Codable, Identifiable {
    let id: String
    let fullName: String
    let email: String
    var role: UserRole
    var allergens: [Allergen]
    
    init(id: String = UUID().uuidString,
         fullName: String,
         email: String,
         role: UserRole,
         allergens: [Allergen] = []) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.role = role
        self.allergens = allergens
    }
}

struct Review: Codable, Identifiable {
    let id: String
    let menuItemId: String
    let userId: String
    let userName: String
    var rating: Int
    var comment: String
    let quickFeedback: [String]
    let date: Date
    var adminResponse: String?
    
    init(id: String = UUID().uuidString,
         menuItemId: String,
         userId: String,
         userName: String,
         rating: Int,
         comment: String = "",
         quickFeedback: [String] = [],
         date: Date = Date(),
         adminResponse: String? = nil) {
        self.id = id
        self.menuItemId = menuItemId
        self.userId = userId
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.quickFeedback = quickFeedback
        self.date = date
        self.adminResponse = adminResponse
    }
}

struct Announcement: Codable, Identifiable {
    let id: String
    let title: String
    let message: String
    let type: AnnouncementType
    let date: Date
    let isImportant: Bool
    
    init(id: String = UUID().uuidString,
         title: String,
         message: String,
         type: AnnouncementType,
         date: Date = Date(),
         isImportant: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.date = date
        self.isImportant = isImportant
    }
}

struct AppPreferences: Codable {
    var isDarkMode: Bool
    var language: String
    var theme: String
    var notifications: NotificationSettings
    
    init(isDarkMode: Bool = false,
         language: String = "tr",
         theme: String = "orange",
         notifications: NotificationSettings = NotificationSettings()) {
        self.isDarkMode = isDarkMode
        self.language = language
        self.theme = theme
        self.notifications = notifications
    }
}

struct NotificationSettings: Codable {
    var dailyMenu: Bool
    var announcements: Bool
    var crowdAlerts: Bool
    
    init(dailyMenu: Bool = true,
         announcements: Bool = true,
         crowdAlerts: Bool = false) {
        self.dailyMenu = dailyMenu
        self.announcements = announcements
        self.crowdAlerts = crowdAlerts
    }
}
