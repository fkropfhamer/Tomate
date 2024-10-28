//
//  TomateApp.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import SwiftUI

@main
struct TomateApp: App {
    init() {
        NotificationHandler.askNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
