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
            // Mint green background like Android
            Color(red: 0.75, green: 0.93, blue: 0.87)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App logo and title
                VStack(spacing: 20) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 50))
                                .foregroundColor(Color(red: 0.4, green: 0.42, blue: 0.47))
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    Text("Kampüs Menü")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                }
                
                Spacer()
                
                // Selection title
                Text("Kullanıcı Seçim Ekranı")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                
                VStack(spacing: 16) {
                    // Admin button
                    Button(action: {
                        selectedRole = .admin
                    }) {
                        HStack(spacing: 16) {
                            Text("👨‍💼")
                                .font(.system(size: 32))
                            
                            Text("Admin Girişi")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                    
                    // Student button
                    Button(action: {
                        selectedRole = .student
                    }) {
                        HStack(spacing: 16) {
                            Text("👨‍🎓")
                                .font(.system(size: 32))
                            
                            Text("Öğrenci Girişi")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.27, blue: 0.31))
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}
