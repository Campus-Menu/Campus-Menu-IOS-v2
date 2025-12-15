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
                name: "Campus Öğrenci",
                email: "ogrenci@campus.com",
                password: "123456",
                studentNumber: "2024001"
            )
            addStudent(demoStudent)
            currentStudent = demoStudent
        }
        
        if menuHistory.isEmpty {
            createYearlyMenus()
        }
        
        if announcements.isEmpty {
            createSampleAnnouncements()
        }
    }
    
    private func createYearlyMenus() {
        let calendar = Calendar.current
        let today = Date()
        
        // Son 6 ay + Gelecek 6 ay = 1 yıl menü
        for daysOffset in -180...180 {
            guard let date = calendar.date(byAdding: .day, value: daysOffset, to: today) else { continue }
            
            // Hafta sonları atla
            let weekday = calendar.component(.weekday, from: date)
            if weekday == 1 || weekday == 7 { // Pazar = 1, Cumartesi = 7
                continue
            }
            
            let items = createDailyMenuItems(for: date)
            let menuDay = MenuDay(date: calendar.startOfDay(for: date), items: items)
            addMenuDay(menuDay)
        }
    }
    
    private func createDailyMenuItems(for date: Date) -> [MenuItem] {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        let weekNumber = calendar.component(.weekOfYear, from: date)
        
        // Haftanın gününe göre farklı menüler
        var items: [MenuItem] = []
        
        // Her gün bir çorba
        let soups = [
            MenuItem(name: "Mercimek Çorbası", description: "Kırmızı mercimek çorbası", category: .soup, calories: 120, allergens: [.gluten]),
            MenuItem(name: "Tavuk Çorbası", description: "Şehriyeli tavuk çorbası", category: .soup, calories: 140, allergens: [.gluten]),
            MenuItem(name: "Domates Çorbası", description: "Kremalı domates çorbası", category: .soup, calories: 110, allergens: [.dairy]),
            MenuItem(name: "Yayla Çorbası", description: "Yoğurtlu yayla çorbası", category: .soup, calories: 130, allergens: [.dairy]),
            MenuItem(name: "Ezogelin Çorbası", description: "Baharatlı ezogelin çorbası", category: .soup, calories: 125)
        ]
        items.append(soups[dayOfWeek % soups.count])
        
        // Ana yemek (haftanın gününe göre)
        switch dayOfWeek {
        case 2: // Pazartesi
            items.append(MenuItem(name: "Tavuk Şinitzel", description: "Gevrek kaplamalı tavuk", category: .lunch, calories: 350, allergens: [.gluten, .eggs]))
            items.append(MenuItem(name: "Pilav", description: "Tereyağlı pirinç pilavı", category: .lunch, calories: 200))
        case 3: // Salı
            items.append(MenuItem(name: "Izgara Köfte", description: "Baharatlı köfte", category: .lunch, calories: 320))
            items.append(MenuItem(name: "Kumpir", description: "Fırın patates", category: .lunch, calories: 280, allergens: [.dairy]))
        case 4: // Çarşamba
            items.append(MenuItem(name: "Tavuk Sote", description: "Sebzeli tavuk sote", category: .lunch, calories: 310))
            items.append(MenuItem(name: "Bulgur Pilavı", description: "Domatesli bulgur pilavı", category: .lunch, calories: 190))
        case 5: // Perşembe
            items.append(MenuItem(name: "Balık", description: "Fırında sebzeli balık", category: .lunch, calories: 290, allergens: [.fish]))
            items.append(MenuItem(name: "Salata", description: "Mevsim salata", category: .lunch, calories: 80))
        case 6: // Cuma
            items.append(MenuItem(name: "Makarna", description: "Domates soslu makarna", category: .lunch, calories: 250, allergens: [.gluten]))
            items.append(MenuItem(name: "Pizza Dilimi", description: "Margarita pizza", category: .lunch, calories: 280, allergens: [.gluten, .dairy]))
        default:
            items.append(MenuItem(name: "Tavuk Şinitzel", description: "Gevrek kaplamalı tavuk", category: .lunch, calories: 350, allergens: [.gluten, .eggs]))
            items.append(MenuItem(name: "Pilav", description: "Tereyağlı pirinç pilavı", category: .lunch, calories: 200))
        }
        
        // Akşam yemeği
        let dinners = [
            MenuItem(name: "Izgara Tavuk", description: "Marine edilmiş tavuk but", category: .dinner, calories: 300),
            MenuItem(name: "Mantı", description: "Yoğurtlu mantı", category: .dinner, calories: 380, allergens: [.gluten, .dairy, .eggs]),
            MenuItem(name: "Etli Nohut", description: "Haşlanmış nohut ve et", category: .dinner, calories: 340),
            MenuItem(name: "Köri Soslu Tavuk", description: "Hindistan cevizli köri sos", category: .dinner, calories: 330),
            MenuItem(name: "Sebze Güveç", description: "Fırında sebze güveç", category: .dinner, calories: 220)
        ]
        items.append(dinners[(dayOfWeek + weekNumber) % dinners.count])
        
        // Tatlı (Hafta içi her gün değişen)
        let desserts = [
            MenuItem(name: "Sütlaç", description: "Fırın sütlaç", category: .dessert, calories: 220, allergens: [.dairy]),
            MenuItem(name: "Kazandibi", description: "Geleneksel kazandibi", category: .dessert, calories: 240, allergens: [.dairy]),
            MenuItem(name: "Aşure", description: "Kuru meyveli aşure", category: .dessert, calories: 200, allergens: [.nuts]),
            MenuItem(name: "Meyve", description: "Mevsim meyveleri", category: .dessert, calories: 80),
            MenuItem(name: "Kek", description: "Çikolatalı kek", category: .dessert, calories: 260, allergens: [.gluten, .eggs, .dairy])
        ]
        items.append(desserts[(dayOfWeek + weekNumber) % desserts.count])
        
        // Kahvaltı
        if dayOfWeek == 2 || dayOfWeek == 4 { // Pazartesi ve Çarşamba
            items.append(MenuItem(name: "Omlet", description: "Kaşarlı omlet", category: .breakfast, calories: 180, allergens: [.eggs, .dairy]))
            items.append(MenuItem(name: "Ekmek", description: "Taze ekmek", category: .breakfast, calories: 150, allergens: [.gluten]))
        }
        
        // Atıştırmalık
        let snacks = [
            MenuItem(name: "Meyve", description: "Taze mevsim meyveleri", category: .snack, calories: 80),
            MenuItem(name: "Yoğurt", description: "Süzme yoğurt", category: .snack, calories: 100, allergens: [.dairy]),
            MenuItem(name: "Ceviz", description: "Kuru ceviz", category: .snack, calories: 120, allergens: [.nuts])
        ]
        items.append(snacks[weekNumber % snacks.count])
        
        return items
    }
    
    private func createSampleAnnouncements() {
        let announcement1 = Announcement(
            title: "Ankara Bilim Üniversitesi Yemekhane",
            content: "Ankara Bilim Üniversitesi öğrencilerine günlük menü bilgisi ve kalori takibi sunan resmi uygulamadır.",
            type: .general
        )
        
        let announcement2 = Announcement(
            title: "Haftalık Menü Güncellendi",
            content: "Bu hafta için yeni ve lezzetli yemekler menümüze eklendi. Favorilerinize eklemeyi unutmayın!",
            type: .menuChange
        )
        
        let announcement3 = Announcement(
            title: "Sağlıklı Beslenme",
            content: "Dengeli beslenme için her öğünde farklı besin gruplarından yiyecekler tüketmeyi unutmayın.",
            type: .event
        )
        
        addAnnouncement(announcement1)
        addAnnouncement(announcement2)
        addAnnouncement(announcement3)
    }
}
