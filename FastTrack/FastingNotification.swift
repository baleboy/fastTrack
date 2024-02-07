//
//  FastingNotification.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 7.2.2024.
//

import Foundation
import UserNotifications

struct FastingNotification {
    let id = UUID().uuidString
    var title = "Default notification"
    var message = "This is a default notification"
    
    func schedule(for notificationTime: Date) {
        
        let content = UNMutableNotificationContent()
                
        // cancel any pending notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        
        content.sound = UNNotificationSound.default

        // for testing
        // let futureDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationTime)
        

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "fastingEndNotification", content: content, trigger: trigger)
        print("Scheduling notification for \(triggerDate)")
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Handle any errors
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
