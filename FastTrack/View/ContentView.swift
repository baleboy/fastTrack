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
    @ObservedObject private var fm: FastManager

    @State private var showingDatePicker = false

    @Environment(\.scenePhase) var scenePhase
    
    private let fastStartNotification = FastingNotification(title: "Start Fasting!", message: "Your eating window has ended, start fasting!")
    private let fastEndNotification = FastingNotification(title: "Fasting Complete!", message: "Your fasting period has ended, good job!")

    var body: some View {
        NavigationStack {
            FastingView(fastManager: fm,timer: timer) {
                toggleFastingState()
            }
            .navigationTitle("FastTrack")
        }
        .onChange(of: fm.latestStartTime) {
            fastEndNotification.schedule(for: fm.currentGoalTime)
            fm.save()
        }
        .onChange(of: fm.latestEndTime) {
            fastStartNotification.schedule(for: fm.nextfastingTime)
            fm.save()
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

        if !fm.isFasting {
            fm.startFasting()
            fastEndNotification.schedule(for: fm.currentGoalTime)
        } else {
            fm.stopFasting()
            fastStartNotification.schedule(for: fm.nextfastingTime)
        }

        timer.start()
        saveState()
    }
        
    init() {
        
        print("loading state")
        
        self.timer = StopWatchTimer.load()
        fm = FastManager()
        fm.load()
    }
    
    func saveState() {
        print("saving state")
        timer.save()
        fm.save()
    }
    
    func formatDateToString(date: Date?) -> String {
        guard let validDate = date else {
            return "—:—"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: validDate)
    }
}


#Preview {
    ContentView()
}
