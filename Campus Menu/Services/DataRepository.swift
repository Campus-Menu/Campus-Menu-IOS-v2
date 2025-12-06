//
//  DataRepository.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import Foundation
import Combine

class DataRepository: ObservableObject {
    static let shared = DataRepository()
    
    @Published var currentUser: User?
    @Published var currentStudent: Student?
    @Published var students: [Student] = []
    @Published var menuHistory: [MenuDay] = []
    @Published var reviews: [Review] = []
    @Published var announcements: [Announcement] = []
    @Published var favorites: [String] = []
    @Published var preferences: AppPreferences = AppPreferences()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private init() {
        loadAllData()
        initializeSampleData()
    }
    
    // MARK: - File Paths
    
    private func filePath(for filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
    
    // MARK: - Generic Save/Load
    
    private func save<T: Encodable>(_ data: T, to filename: String) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: filePath(for: filename))
        } catch {
            print("Error saving \(filename): \(error)")
        }
    }
    
    private func load<T: Decodable>(from filename: String) -> T? {
        let path = filePath(for: filename)
        guard FileManager.default.fileExists(atPath: path.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error loading \(filename): \(error)")
            return nil
        }
    }
    
    // MARK: - Load All Data
    
    func loadAllData() {
        students = load(from: "students.json") ?? []
        menuHistory = load(from: "menu_history.json") ?? []
        reviews = load(from: "reviews.json") ?? []
        announcements = load(from: "announcements.json") ?? []
        favorites = load(from: "favorites.json") ?? []
        preferences = load(from: "preferences.json") ?? AppPreferences()
        
        if let userData: User = load(from: "current_user.json") {
            currentUser = userData
        }
        if let studentData: Student = load(from: "current_student.json") {
            currentStudent = studentData
        }
    }
    
    // MARK: - Students
    
    func saveStudents() {
        save(students, to: "students.json")
    }
    
    func addStudent(_ student: Student) {
        students.append(student)
        saveStudents()
    }
    
    func findStudent(email: String) -> Student? {
        return students.first { $0.email == email }
    }
    
    func updateStudent(_ student: Student) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
            saveStudents()
            
            // Update currentStudent if this is the logged-in user
            if currentStudent?.id == student.id {
                currentStudent = student
            }
        }
    }
    
    // MARK: - Menu
    
    func saveMenuHistory() {
        save(menuHistory, to: "menu_history.json")
    }
    
    func getTodayMenu() -> MenuDay? {
        let calendar = Calendar.current
        return menuHistory.first { calendar.isDateInToday($0.date) }
    }
    
    func getMenu(for date: Date) -> MenuDay? {
        let calendar = Calendar.current
        return menuHistory.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func addMenuDay(_ menuDay: MenuDay) {
        menuHistory.append(menuDay)
        saveMenuHistory()
    }
    
    func updateMenuDay(_ menuDay: MenuDay) {
        if let index = menuHistory.firstIndex(where: { $0.id == menuDay.id }) {
            menuHistory[index] = menuDay
            saveMenuHistory()
        }
    }
    
    func deleteMenuDay(_ menuDayId: String) {
        menuHistory.removeAll { $0.id == menuDayId }
        saveMenuHistory()
    }
    
    func updateMenuItem(_ item: MenuItem) {
        for (dayIndex, menuDay) in menuHistory.enumerated() {
            if let itemIndex = menuDay.items.firstIndex(where: { $0.id == item.id }) {
                menuHistory[dayIndex].items[itemIndex] = item
                saveMenuHistory()
                return
            }
        }
    }
    
    func deleteMenuItem(_ itemId: String) {
        for (dayIndex, menuDay) in menuHistory.enumerated() {
            if let itemIndex = menuDay.items.firstIndex(where: { $0.id == itemId }) {
                menuHistory[dayIndex].items.remove(at: itemIndex)
                saveMenuHistory()
                return
            }
        }
    }
    
    // MARK: - Reviews
    
    func saveReviews() {
        save(reviews, to: "reviews.json")
    }
    
    func addReview(_ review: Review) {
        reviews.append(review)
        saveReviews()
        updateMenuItemRating(for: review.menuItemId)
    }
    
    func getReviews(for menuItemId: String) -> [Review] {
        return reviews.filter { $0.menuItemId == menuItemId }
    }
    
    func updateReview(_ review: Review) {
        if let index = reviews.firstIndex(where: { $0.id == review.id }) {
            reviews[index] = review
            saveReviews()
        }
    }
    
    func deleteReview(_ reviewId: String) {
        if let review = reviews.first(where: { $0.id == reviewId }) {
            let menuItemId = review.menuItemId
            reviews.removeAll { $0.id == reviewId }
            saveReviews()
            updateMenuItemRating(for: menuItemId)
        }
    }
    
    private func updateMenuItemRating(for menuItemId: String) {
        let itemReviews = getReviews(for: menuItemId)
        guard !itemReviews.isEmpty else { return }
        
        let sum = itemReviews.reduce(0) { $0 + $1.rating }
        let average = Double(sum) / Double(itemReviews.count)
        let rounded = round(average * 10) / 10 // Round to 1 decimal
        
        for (dayIndex, menuDay) in menuHistory.enumerated() {
            if let itemIndex = menuDay.items.firstIndex(where: { $0.id == menuItemId }) {
                menuHistory[dayIndex].items[itemIndex].rating = rounded
                menuHistory[dayIndex].items[itemIndex].reviewCount = itemReviews.count
                saveMenuHistory()
                return
            }
        }
    }
    
    // MARK: - Announcements
    
    func saveAnnouncements() {
        save(announcements, to: "announcements.json")
    }
    
    func addAnnouncement(_ announcement: Announcement) {
        announcements.insert(announcement, at: 0)
        saveAnnouncements()
    }
    
    func deleteAnnouncement(_ announcementId: String) {
        announcements.removeAll { $0.id == announcementId }
        saveAnnouncements()
    }
    
    // MARK: - Favorites
    
    func saveFavorites() {
        save(favorites, to: "favorites.json")
    }
    
    func toggleFavorite(_ itemId: String) {
        if favorites.contains(itemId) {
            favorites.removeAll { $0 == itemId }
        } else {
            favorites.append(itemId)
        }
        saveFavorites()
    }
    
    func isFavorite(_ itemId: String) -> Bool {
        return favorites.contains(itemId)
    }
    
    // MARK: - Preferences
    
    func savePreferences() {
        save(preferences, to: "preferences.json")
    }
    
    func updatePreferences(_ prefs: AppPreferences) {
        preferences = prefs
        savePreferences()
    }
    
    // MARK: - Auth
    
    func login(email: String, password: String) -> User? {
        // Check admin
        if email == "admin@campus.com" && password == "admin123" {
            let user = User(fullName: "Admin", email: email, role: .admin)
            currentUser = user
            save(user, to: "current_user.json")
            return user
        }
        
        // Check student
        if let student = findStudent(email: email), student.password == password {
            let user = User(id: student.id, fullName: student.name, email: student.email, role: .student)
            currentUser = user
            currentStudent = student
            save(user, to: "current_user.json")
            save(student, to: "current_student.json")
            return user
        }
        
        return nil
    }
    
    func register(student: Student) {
        addStudent(student)
        _ = login(email: student.email, password: student.password)
    }
    
    func logout() {
        currentUser = nil
        currentStudent = nil
        try? FileManager.default.removeItem(at: filePath(for: "current_user.json"))
        try? FileManager.default.removeItem(at: filePath(for: "current_student.json"))
    }
    
    func updateUserAllergens(_ allergens: [Allergen]) {
        guard var student = currentStudent else { return }
        student.allergens = allergens
        currentStudent = student
        
        // Update in students array
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index] = student
            save(students, to: "students.json")
        }
        
        save(student, to: "current_student.json")
    }
    
    // MARK: - Sample Data
    
    func initializeSampleData() {
        // Only create sample data if it doesn't exist
        if students.isEmpty {
            let demoStudent = Student(
                name: "Demo Öğrenci",
                email: "ogrenci@campus.com",
                password: "123456",
                studentNumber: "2024001"
            )
            addStudent(demoStudent)
        }
        
        if menuHistory.isEmpty {
            createSampleMenus()
        }
        
        if announcements.isEmpty {
            createSampleAnnouncements()
        }
    }
    
    private func createSampleMenus() {
        let calendar = Calendar.current
        
        for daysAgo in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else { continue }
            
            let items = createSampleMenuItems()
            let menuDay = MenuDay(date: date, items: items)
            addMenuDay(menuDay)
        }
    }
    
    private func createSampleMenuItems() -> [MenuItem] {
        return [
            MenuItem(name: "Mercimek Çorbası", description: "Geleneksel kırmızı mercimek çorbası", category: .soup, calories: 120, allergens: [.gluten]),
            MenuItem(name: "Tavuk Şinitzel", description: "Gevrek kaplamalı tavuk göğsü", category: .lunch, calories: 350, allergens: [.gluten, .eggs]),
            MenuItem(name: "Pilav", description: "Tereyağlı pirinç pilavı", category: .lunch, calories: 200),
            MenuItem(name: "Izgara Köfte", description: "Baharatlı köfte", category: .dinner, calories: 320),
            MenuItem(name: "Sütlaç", description: "Fırın sütlaç", category: .dessert, calories: 220, allergens: [.dairy]),
            MenuItem(name: "Omlet", description: "Kaşarlı omlet", category: .breakfast, calories: 180, allergens: [.eggs, .dairy]),
            MenuItem(name: "Makarna", description: "Domates soslu makarna", category: .lunch, calories: 250, allergens: [.gluten]),
            MenuItem(name: "Meyve", description: "Mevsim meyveleri", category: .snack, calories: 80)
        ]
    }
    
    private func createSampleAnnouncements() {
        let announcement1 = Announcement(
            title: "Bakım Çalışması",
            content: "Yemekhane bu hafta sonu bakım çalışmaları nedeniyle kapalı olacaktır.",
            type: .maintenance
        )
        
        let announcement2 = Announcement(
            title: "Yeni Menü Dönemi",
            content: "Önümüzdeki hafta yeni menü dönemi başlıyor. Lezzetli yemekler sizi bekliyor!",
            type: .general
        )
        
        addAnnouncement(announcement1)
        addAnnouncement(announcement2)
    }
}
