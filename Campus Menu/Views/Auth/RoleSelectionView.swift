//
//  RoleSelectionView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct RoleSelectionView: View {
    @Binding var selectedRole: UserRole?
    
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    themeManager.currentTheme.primary,
                    themeManager.currentTheme.secondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Title
                VStack(spacing: 12) {
                    Text("🍽️")
                        .font(.system(size: 80))
                    
                    Text(localization.localized("role_selection"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(localization.localized("select_role"))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Role cards
                VStack(spacing: 20) {
                    RoleCard(
                        icon: "graduationcap.fill",
                        title: localization.localized("student"),
                        description: localization.localized("student_desc")
                    ) {
                        selectedRole = .student
                    }
                    
                    RoleCard(
                        icon: "person.badge.key.fill",
                        title: localization.localized("admin"),
                        description: localization.localized("admin_desc")
                    ) {
                        selectedRole = .admin
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(20)
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
