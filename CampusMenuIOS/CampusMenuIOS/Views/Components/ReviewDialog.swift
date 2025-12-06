//
//  ReviewDialog.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct ReviewDialog: View {
    let menuItem: MenuItem
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var rating: Int = 0
    @State private var comment: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Menu item info
                VStack(spacing: 8) {
                    Text(menuItem.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                    
                    HStack(spacing: 4) {
                        Text(menuItem.category.icon)
                        Text(localization.localized(menuItem.category.localizedKey))
                            .font(.subheadline)
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                }
                .padding(.top)
                
                Divider()
                
                // Rating stars
                VStack(spacing: 8) {
                    Text(localization.localized("your_rating"))
                        .font(.headline)
                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                    
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                rating = star
                            }) {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.system(size: 32))
                                    .foregroundColor(star <= rating ? .yellow : Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            }
                        }
                    }
                }
                
                // Comment text field
                VStack(alignment: .leading, spacing: 8) {
                    Text(localization.localized("review"))
                        .font(.headline)
                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                    
                    TextEditor(text: $comment)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.adaptiveSurface(themeManager.isDarkMode))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.adaptiveBorder(themeManager.isDarkMode), lineWidth: 1)
                        )
                    
                    if comment.isEmpty {
                        Text(localization.localized("write_review"))
                            .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            .font(.subheadline)
                            .padding(.leading, 12)
                            .padding(.top, -92)
                            .allowsHitTesting(false)
                    }
                }
                
                Spacer()
                
                // Submit button
                Button(action: submitReview) {
                    Text(localization.localized("submit_review"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(rating > 0 ? themeManager.currentTheme.primary : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(rating == 0)
            }
            .padding()
            .background(Color.adaptiveBackground(themeManager.isDarkMode))
            .navigationTitle(localization.localized("rate_menu"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
            }
        }
    }
    
    private func submitReview() {
        guard rating > 0, let student = repository.currentStudent else { return }
        
        let review = Review(
            studentId: student.id,
            studentName: student.name,
            menuItemId: menuItem.id,
            menuItemName: menuItem.name,
            rating: rating,
            comment: comment.isEmpty ? nil : comment
        )
        
        repository.addReview(review)
        dismiss()
    }
}
