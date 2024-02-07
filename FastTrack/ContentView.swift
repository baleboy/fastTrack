//
//  ContentView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 17.1.2024.
//

import SwiftUI
import UserNotifications

struct ContentView: View {

    @ObservedObject private var timer: StopWatchTimer
    @ObservedObject private var fast: Fast

    @State private var showingDatePicker = false
    
    enum DatePickerSelection {
        case start
        case end
    }
    @State private var datePickerSelection : DatePickerSelection = .start

    @Environment(\.scenePhase) var scenePhase
    
    private let fastingHours = 16
    
    var fastingTargetTime: Double {
        return Double(fastingHours) * 3600.0
    }
    
    var eatingTargetTime: Double {
        return (24.0 - Double(fastingHours)) * 3600.0
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(fast.fasting ? "FASTING" : "NOT FASTING").font(.title)
            Text (fastingText).padding(10).font(.caption)
            Text(elapsedText)
                .font(.largeTitle.monospacedDigit())
            
            let targetTime = fast.fasting ? fastingTargetTime : eatingTargetTime
            
            ProgressView(value: elapsed, total: targetTime)
            HStack {
                Button {
                    self.datePickerSelection = .start
                    self.showingDatePicker = true
                } label: {
                    VStack {
                    Text("Started")
                        Text(formatDateToString(date: fast.startTime))
                    }
                }.disabled(fast.startTime == nil)
                Spacer()
                Button {
                    self.datePickerSelection = .end
                    self.showingDatePicker = true
                } label: {
                    VStack {
                        Text(fast.fasting ? "Goal" : "Ended")
                        Text(formatDateToString(date: fast.fasting ? fastingGoalTime : fast.endTime))
                    }
                }.disabled(fast.endTime == nil)
            }
            Button(){
                toggleFastingState()
            } label: {
                if !fast.fasting {
                    Text("Start Fasting")
                } else {
                    Text("Stop Fasting")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Spacer()
        }
        .padding(80)
        .sheet(isPresented: $showingDatePicker, onDismiss: saveState) {
            VStack {
                if datePickerSelection == .start {
                    DatePicker("Select Start Time", selection: Binding($fast.startTime)!, displayedComponents: .hourAndMinute)
                } else {
                    DatePicker("Select End Time", selection: Binding($fast.endTime)!, displayedComponents: .hourAndMinute)
                }
                Button {
                    showingDatePicker = false
                } label: {
                    Text("Done")
                }.buttonStyle(.borderedProminent)
                .padding()
            }
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
        }
        .onChange(of: fast.startTime) {
            scheduleFastingNotification(for: fastingGoalTime, type: .fastingEnd)
        }
        .onChange(of: fast.endTime) {
            scheduleFastingNotification(for: plannedFastingTime, type: .fastingStart)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                timer.stop()
            } else if scenePhase == .active {
                timer.resume()
            }
        }
    }

    func toggleFastingState() {

        fast.toggle()

        if fast.fasting {
            scheduleFastingNotification(for: fastingGoalTime, type: .fastingEnd)
        } else {
            scheduleFastingNotification(for: plannedFastingTime, type: .fastingStart)
        }
        timer.start()
        saveState()
    }
        
    var fastingText: String {
        return fast.fasting ? "Time fasting" : "Time since last fast"
    }
    
    var elapsed: TimeInterval {
        
        let startTime = fast.endTime ?? fast.startTime ?? Date()
    
        return Date().timeIntervalSince(startTime)
    }
    
    var elapsedText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        // Convert TimeInterval to String
        let formattedString = formatter.string(from: elapsed) ?? "Invalid Interval"
        
        return formattedString
    }
    
    init() {
        
        print("loading state")
        
        self.timer = StopWatchTimer.load()
        self.fast = Fast.load()
    }
    

    func saveState() {
        print("saving state")
        timer.save()
        fast.save()
    }
    
    func formatDateToString(date: Date?) -> String {
        guard let validDate = date else {
            return "—:—"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: validDate)
    }
    
    var fastingGoalTime: Date {
        if let startTime = fast.startTime {
            return Calendar.current.date(
                byAdding: .hour, value: fastingHours, to: startTime) ?? Date()
        }
        
        return Date()
    }
    
    var plannedFastingTime: Date {
        if let endTime = fast.endTime {
            return Calendar.current.date(
                byAdding: .hour, value: 24 - fastingHours, to: endTime) ?? Date()
        }
        
        return Date()
    }

    
    enum FastingNotificationType {
        case fastingStart
        case fastingEnd
    }
    
    func scheduleFastingNotification(for notificationTime: Date, type: FastingNotificationType) {
        
        let id: String
        let content = UNMutableNotificationContent()

        if type == .fastingEnd {
            id = "fastingEndNotification"
            content.title = "Fasting Complete!"
            content.body = "Your fasting period has ended. Great job!"
        } else {
            id = "fastingStartNotification"
            content.title = "Start fasting!"
            content.body = "Your eating window has ended. Start fasting!"
        }
                
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


#Preview {
    ContentView()
}
