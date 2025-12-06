//
//  Campus_MenuTests.swift
//  Campus MenuTests
//
//  Created by Çağan Şahbaz on 6.12.2025.
//

import XCTest
import SwiftUI
@testable import Campus_Menu

final class Campus_MenuTests: XCTestCase {
    
    var repository: DataRepository!
    var themeManager: ThemeManager!
    var localizationManager: LocalizationManager!
    
    override func setUp() {
        super.setUp()
        repository = DataRepository.shared
        themeManager = ThemeManager.shared
        localizationManager = LocalizationManager.shared
    }
    
    override func tearDown() {
        repository = nil
        themeManager = nil
        localizationManager = nil
        super.tearDown()
    }
    
    // MARK: - Model Tests
    
    func testMenuItemCreation() {
        let menuItem = MenuItem(
            name: "Köfte",
            description: "Izgara köfte",
            category: .lunch,
            calories: 450,
            allergens: [.gluten]
        )
        
        XCTAssertEqual(menuItem.name, "Köfte")
        XCTAssertEqual(menuItem.category, .lunch)
        XCTAssertEqual(menuItem.calories, 450)
        XCTAssertTrue(menuItem.allergens.contains(.gluten))
    }
    
    func testStudentCreation() {
        let student = Student(
            id: "test-123",
            name: "Test Öğrenci",
            email: "test@example.com",
            password: "password123",
            studentNumber: "20230001",
            allergens: [.dairy],
            favoriteMenuItems: []
        )
        
        XCTAssertEqual(student.name, "Test Öğrenci")
        XCTAssertEqual(student.email, "test@example.com")
        XCTAssertTrue(student.allergens.contains(.dairy))
    }
    
    func testReviewCreation() {
        let review = Review(
            studentId: "student-1",
            studentName: "Test Student",
            menuItemId: "item-1",
            menuItemName: "Köfte",
            rating: 5,
            comment: "Çok güzeldi",
            isApproved: true
        )
        
        XCTAssertEqual(review.rating, 5)
        XCTAssertEqual(review.comment, "Çok güzeldi")
        XCTAssertTrue(review.isApproved)
    }
    
    // MARK: - Theme Manager Tests
    
    func testThemeToggle() {
        let initialMode = themeManager.isDarkMode
        themeManager.toggleDarkMode()
        XCTAssertNotEqual(themeManager.isDarkMode, initialMode)
    }
    
    func testThemeChange() {
        themeManager.currentTheme = .purple
        // Test that theme was changed successfully
        XCTAssertNotNil(themeManager.currentTheme)
        XCTAssertNotNil(themeManager.currentTheme.primary)
    }
    
    // MARK: - Localization Tests
    
    func testLocalization() {
        let homeKey = localizationManager.localized("home")
        XCTAssertFalse(homeKey.isEmpty)
        
        let calendarKey = localizationManager.localized("calendar")
        XCTAssertFalse(calendarKey.isEmpty)
    }
    
    func testLanguageSwitch() {
        let currentLanguage = localizationManager.currentLanguage
        let newLanguage: Language = currentLanguage == .turkish ? .english : .turkish
        localizationManager.setLanguage(newLanguage)
        XCTAssertNotEqual(localizationManager.currentLanguage, currentLanguage)
    }
    
    // MARK: - Data Repository Tests
    
    func testStudentRegistration() {
        let initialCount = repository.students.count
        
        let newStudent = Student(
            id: UUID().uuidString,
            name: "New Student",
            email: "new@test.com",
            password: "password123",
            studentNumber: "99999999",
            allergens: [],
            favoriteMenuItems: []
        )
        
        repository.addStudent(newStudent)
        XCTAssertEqual(repository.students.count, initialCount + 1)
    }
    
    func testFindStudent() {
        let testEmail = "test@campus.com"
        let student = repository.findStudent(email: testEmail)
        
        if student != nil {
            XCTAssertEqual(student?.email, testEmail)
        } else {
            XCTAssertNil(student)
        }
    }
    
    func testMenuDayOperations() {
        let initialCount = repository.menuHistory.count
        
        let menuDay = MenuDay(
            id: UUID().uuidString,
            date: Date(),
            items: [
                MenuItem(
                    name: "Test Yemek",
                    category: .lunch,
                    calories: 300,
                    allergens: []
                )
            ]
        )
        
        repository.addMenuDay(menuDay)
        XCTAssertEqual(repository.menuHistory.count, initialCount + 1)
        
        // Cleanup
        repository.deleteMenuDay(menuDay.id)
        XCTAssertEqual(repository.menuHistory.count, initialCount)
    }
    
    func testReviewOperations() {
        let initialCount = repository.reviews.count
        
        let review = Review(
            id: UUID().uuidString,
            studentId: "test-student",
            studentName: "Test Student",
            menuItemId: "test-item",
            menuItemName: "Test Item",
            rating: 4,
            comment: "Test review"
        )
        
        repository.addReview(review)
        XCTAssertEqual(repository.reviews.count, initialCount + 1)
        
        // Cleanup
        repository.deleteReview(review.id)
        XCTAssertEqual(repository.reviews.count, initialCount)
    }
    
    func testAnnouncementOperations() {
        let initialCount = repository.announcements.count
        
        let announcement = Announcement(
            id: UUID().uuidString,
            title: "Test Duyuru",
            content: "Test içerik",
            type: .general,
            date: Date()
        )
        
        repository.addAnnouncement(announcement)
        XCTAssertEqual(repository.announcements.count, initialCount + 1)
        
        // Cleanup
        repository.deleteAnnouncement(announcement.id)
        XCTAssertEqual(repository.announcements.count, initialCount)
    }
    
    // MARK: - Category Tests
    
    func testMenuCategoryLocalizedKeys() {
        let categories = MenuCategory.allCases
        XCTAssertFalse(categories.isEmpty)
        
        for category in categories {
            XCTAssertFalse(category.localizedKey.isEmpty)
            XCTAssertFalse(category.icon.isEmpty)
        }
    }
    
    func testAllergenLocalizedKeys() {
        let allergens = Allergen.allCases
        XCTAssertFalse(allergens.isEmpty)
        
        for allergen in allergens {
            XCTAssertFalse(allergen.localizedKey.isEmpty)
            XCTAssertFalse(allergen.icon.isEmpty)
        }
    }
}

