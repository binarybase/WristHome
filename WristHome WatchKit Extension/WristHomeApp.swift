//
//  WristHomeApp.swift
//  WristHome WatchKit Extension
//
//  Created by Tomas on 31.07.2022.
//

import SwiftUI

@main
struct WristHomeApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
