//
//  StudentLoginView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct StudentLoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var selectedRole: UserRole?
    @Binding var showRegister: Bool
    
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
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text(localization.localized("student"))
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
                        
                        // Register link
                        Button(action: {
                            showRegister = true
                        }) {
                            HStack(spacing: 4) {
                                Text(localization.localized("no_account"))
                                Text(localization.localized("register"))
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .font(.subheadline)
                        }
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
            if user.role == .student {
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
