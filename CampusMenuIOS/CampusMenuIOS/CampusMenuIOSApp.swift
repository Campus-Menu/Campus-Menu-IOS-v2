//
//  Campus_MenuApp.swift
//  Campus Menu
//
//  Created by Cagan Sahbaz on 12/5/24.
//

import SwiftUI

@main
struct CampusMenuIOSApp: App {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var dataRepository = DataRepository.shared
    
    init() {
        // Initialize sample data on first launch
        DataRepository.shared.initializeSampleData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
