//
//  TomateApp.swift
//  Tomate WatchKit Extension
//
//  Created by Fabian Kropfhamer on 28.01.22.
//

import SwiftUI

@main
struct TomateApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
