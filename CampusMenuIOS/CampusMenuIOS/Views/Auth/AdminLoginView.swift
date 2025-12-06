//
//  AdminLoginView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct AdminLoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var selectedRole: UserRole?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    themeManager.currentTheme.primary,
                    themeManager.currentTheme.secondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 60)
                    
                    // Icon
                    Image(systemName: "person.badge.key.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text(localization.localized("admin"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Login form
                    VStack(spacing: 16) {
                        CustomTextField(
                            icon: "envelope.fill",
                            placeholder: localization.localized("email"),
                            text: $email
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        
                        CustomTextField(
                            icon: "lock.fill",
                            placeholder: localization.localized("password"),
                            text: $password,
                            isSecure: true
                        )
                        
                        if showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        Button(action: handleLogin) {
                            Text(localization.localized("login"))
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Back button
                    Button(action: {
                        selectedRole = nil
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(localization.localized("role_selection"))
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = localization.localized("please_fill_all")
            showError = true
            return
        }
        
        if let user = repository.login(email: email, password: password) {
            if user.role == .admin {
                isLoggedIn = true
            } else {
                errorMessage = localization.localized("invalid_credentials")
                showError = true
            }
        } else {
            errorMessage = localization.localized("invalid_credentials")
            showError = true
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}
