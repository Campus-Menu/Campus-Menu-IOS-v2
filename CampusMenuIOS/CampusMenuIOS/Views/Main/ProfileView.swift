//
//  ProfileView.swift
//  CampusMenuIOS
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    
    @ObservedObject var repository = DataRepository.shared
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Orange header
            VStack(spacing: 16) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                    )
                
                if let student = repository.currentStudent {
                    Text(student.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(student.email)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Text("Öğrenci")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                LinearGradient(
                    colors: [Color.orange, Color.orange.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Menu list
            ScrollView {
                VStack(spacing: 0) {
                    ProfileMenuItem(
                        icon: "location.fill",
                        title: "Alerjilerim",
                        subtitle: "Alerji bilgisi ekle"
                    ) {
                        // Navigate to allergens
                    }
                    
                    Divider().padding(.leading, 60)
                    
                    ProfileMenuItem(
                        icon: "gearshape.fill",
                        title: "Ayarlar"
                    ) {
                        // Navigate to settings
                    }
                    
                    Divider().padding(.leading, 60)
                    
                    ProfileMenuItem(
                        icon: "bell.fill",
                        title: "Bildirimler"
                    ) {
                        // Navigate to notifications
                    }
                    
                    Divider().padding(.leading, 60)
                    
                    ProfileMenuItem(
                        icon: "info.circle.fill",
                        title: "Hakkında"
                    ) {
                        // Navigate to about
                    }
                    
                    Divider().padding(.leading, 60)
                    
                    ProfileMenuItem(
                        icon: "questionmark.circle.fill",
                        title: "Yardım & Destek"
                    ) {
                        // Navigate to help
                    }
                    
                    Divider()
                    
                    Button(action: {
                        repository.logout()
                        isLoggedIn = false
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                                .frame(width: 28)
                            
                            Text("Çıkış Yap")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
                .background(Color.white)
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        }
        .navigationBarHidden(true)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    var subtitle: String = ""
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
        }
    }
}
