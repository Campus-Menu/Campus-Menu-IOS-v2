//
//  StudentRegisterView.swift
//  CampusMenuIOS
//
//  Created on 2025-12-06.
//

import SwiftUI

struct StudentRegisterView: View {
    @Binding var isPresented: Bool
    @Binding var isLoggedIn: Bool
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var studentNumber: String = ""
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
                    Spacer(minLength: 40)
                    
                    // Icon
                    Image(systemName: "person.badge.plus.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                    
                    Text(localization.localized("register"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Register form
                    VStack(spacing: 16) {
                        CustomTextField(
                            icon: "person.fill",
                            placeholder: localization.localized("name"),
                            text: $name
                        )
                        
                        CustomTextField(
                            icon: "number",
                            placeholder: localization.localized("student_number"),
                            text: $studentNumber
                        )
                        .keyboardType(.numberPad)
                        
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
                        
                        Button(action: handleRegister) {
                            Text(localization.localized("register"))
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                        
                        // Login link
                        Button(action: {
                            isPresented = false
                        }) {
                            HStack(spacing: 4) {
                                Text(localization.localized("have_account"))
                                Text(localization.localized("login"))
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 30)
                }
            }
        }
    }
    
    private func handleRegister() {
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty && !studentNumber.isEmpty else {
            errorMessage = localization.localized("please_fill_all")
            showError = true
            return
        }
        
        let newStudent = Student(
            id: UUID().uuidString,
            name: name,
            email: email,
            password: password,
            studentNumber: studentNumber,
            allergens: [],
            favoriteMenuItems: []
        )
        
        repository.register(student: newStudent)
        _ = repository.login(email: email, password: password)
        isLoggedIn = true
        isPresented = false
    }
}
