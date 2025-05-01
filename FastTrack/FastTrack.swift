//
//  FastTrackApp.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 17.1.2024.
//

import SwiftUI
import UserNotifications

@main
struct FastTrack: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            FastTrackView()
        }
    }
}
