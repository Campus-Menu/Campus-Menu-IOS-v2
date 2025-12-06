//
//  AdminReviewsView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct AdminReviewsView: View {
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @State private var selectedFilter: ReviewFilter = .pending
    @State private var selectedReview: Review? = nil
    @State private var showResponseDialog = false
    
    enum ReviewFilter: String, CaseIterable {
        case pending
        case approved
        case all
        
        var localizedKey: String {
            switch self {
            case .pending: return "pending"
            case .approved: return "approved"
            case .all: return "all_reviews"
            }
        }
    }
    
    var filteredReviews: [Review] {
        let filtered: [Review]
        switch selectedFilter {
        case .pending:
            filtered = repository.reviews.filter { !$0.isApproved }
        case .approved:
            filtered = repository.reviews.filter { $0.isApproved }
        case .all:
            filtered = repository.reviews
        }
        return filtered.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter tabs
                    Picker("", selection: $selectedFilter) {
                        ForEach(ReviewFilter.allCases, id: \.self) { filter in
                            Text(localization.localized(filter.localizedKey))
                                .tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if filteredReviews.isEmpty {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Image(systemName: "star.slash")
                                .font(.system(size: 60))
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            
                            Text(localization.localized("no_reviews"))
                                .font(.headline)
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                        }
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredReviews) { review in
                                    AdminReviewCard(review: review) {
                                        selectedReview = review
                                        showResponseDialog = true
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(localization.localized("review_management"))
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showResponseDialog) {
                if let review = selectedReview {
                    AdminResponseView(review: review)
                }
            }
        }
    }
}

struct AdminReviewCard: View {
    let review: Review
    let onRespond: () -> Void
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.studentName)
                        .font(.headline)
                        .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                    
                    Text(review.menuItemName)
                        .font(.subheadline)
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(star <= review.rating ? .yellow : Color.adaptiveTextSecondary(themeManager.isDarkMode))
                    }
                }
            }
            
            Text(review.date, style: .date)
                .font(.caption)
                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
            
            if let comment = review.comment {
                Text(comment)
                    .font(.subheadline)
                    .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
            }
            
            // Status badge
            HStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: review.isApproved ? "checkmark.circle.fill" : "clock.fill")
                        .font(.caption)
                    Text(localization.localized(review.isApproved ? "approved" : "pending"))
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background((review.isApproved ? Color.green : Color.orange).opacity(0.2))
                .foregroundColor(review.isApproved ? .green : .orange)
                .cornerRadius(8)
                
                if review.adminResponse != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left.fill")
                            .font(.caption)
                        Text(localization.localized("responded"))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
            }
            
            // Admin response
            if let response = review.adminResponse {
                Divider()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localization.localized("admin_response"))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.currentTheme.primary)
                    
                    Text(response)
                        .font(.subheadline)
                        .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                }
            }
            
            // Actions
            HStack(spacing: 12) {
                if !review.isApproved {
                    Button(action: {
                        var updatedReview = review
                        updatedReview.isApproved = true
                        repository.updateReview(updatedReview)
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text(localization.localized("approve"))
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
                
                Button(action: onRespond) {
                    HStack {
                        Image(systemName: "bubble.left")
                        Text(localization.localized("respond"))
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(themeManager.currentTheme.primary)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.adaptiveCard(themeManager.isDarkMode))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(themeManager.isDarkMode ? 0.3 : 0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Admin Response View

struct AdminResponseView: View {
    let review: Review
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State private var responseText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.adaptiveBackground(themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Review info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(review.menuItemName)
                            .font(.headline)
                            .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                        
                        HStack {
                            Text(review.studentName)
                                .font(.subheadline)
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundColor(star <= review.rating ? .yellow : Color.adaptiveTextSecondary(themeManager.isDarkMode))
                                }
                            }
                        }
                        
                        if let comment = review.comment {
                            Text(comment)
                                .font(.subheadline)
                                .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color.adaptiveCard(themeManager.isDarkMode))
                    .cornerRadius(12)
                    
                    // Response editor
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.localized("admin_response"))
                            .font(.headline)
                            .foregroundColor(Color.adaptiveText(themeManager.isDarkMode))
                        
                        TextEditor(text: $responseText)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color.adaptiveSurface(themeManager.isDarkMode))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.adaptiveBorder(themeManager.isDarkMode), lineWidth: 1)
                            )
                        
                        if responseText.isEmpty && review.adminResponse == nil {
                            Text(localization.localized("write_response"))
                                .foregroundColor(Color.adaptiveTextSecondary(themeManager.isDarkMode))
                                .font(.subheadline)
                                .padding(.leading, 12)
                                .padding(.top, -142)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    Spacer()
                    
                    // Submit button
                    Button(action: {
                        if !responseText.isEmpty {
                            var updatedReview = review
                            updatedReview.adminResponse = responseText
                            updatedReview.isApproved = true
                            repository.updateReview(updatedReview)
                            dismiss()
                        }
                    }) {
                        Text(localization.localized("submit_review"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(responseText.isEmpty ? Color.gray : themeManager.currentTheme.primary)
                            .cornerRadius(12)
                    }
                    .disabled(responseText.isEmpty)
                }
                .padding()
            }
            .navigationTitle(localization.localized("respond"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localization.localized("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme.primary)
                }
            }
            .onAppear {
                responseText = review.adminResponse ?? ""
            }
        }
    }
}
