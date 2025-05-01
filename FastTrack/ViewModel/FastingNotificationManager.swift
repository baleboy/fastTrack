//
//  FastingNotificationManager.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 28.4.2025.
//

import Foundation
import UserNotifications

class FastingNotificationManager {
        
    private let fastStartNotification = FastingNotification(
        title: "Start Fasting!",
        message: "Your eating window has ended, start fasting!"
    )
    
    private let fastEndNotification = FastingNotification(
        title: "Fasting Complete!",
        message: "Your fasting period has ended, good job!"
    )
    
    func scheduleFastStartNotification(for dateTime: Date?) {
        if let dateTime {
            fastEndNotification.schedule(for: dateTime)
        }
    }
    
    func scheduleFastEndNotification(for dateTime: Date?) {
        if let dateTime {
            fastEndNotification.schedule(for: dateTime)
        }
    }
}
