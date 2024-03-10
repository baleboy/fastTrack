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
    // private var fast: Fast
    @ObservedObject private var fm: FastManager

    @State private var showingDatePicker = false

    @Environment(\.scenePhase) var scenePhase
    
    private let fastStartNotification = FastingNotification(title: "Start Fasting!", message: "Your eating window has ended, start fasting!")
    private let fastEndNotification = FastingNotification(title: "Fasting Complete!", message: "Your fasting period has ended, good job!")

    var body: some View {
        VStack {
            if fm.streak > 0 {
                Text("Streak: \(fm.streak)🔥")
            }
            Spacer()
            Text(fm.isFasting ? "FASTING" : "NOT FASTING").font(.title)
            Text (fastingText).padding(10).font(.caption)
            Text(elapsedText)
                .font(.largeTitle.monospacedDigit())
            
            let currentDuration = fm.isFasting ? fm.fastingDuration : fm.eatingDuration
            
            ProgressView(value: elapsed, total: currentDuration)
            
            Group {
                if let _ = fm.latestFast {
                    EditableFastView(fast: Binding(
                        get: { self.fm.latestFast ?? Fast() },
                        set: { self.fm.updateLatestFast(with: $0) }
                    ))
                } else {
                    Text("Not fasted yet")
                }
            }

            Button(){
                toggleFastingState()
            } label: {
                Text(fm.isFasting ? "Stop Fasting" : "Start Fasting")
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Spacer()
        }
        .padding(80)
        .onChange(of: fm.latestStartTime) {
            fastEndNotification.schedule(for: fm.currentGoalTime)
        }
        .onChange(of: fm.latestEndTime) {
            fastStartNotification.schedule(for: fm.nextfastingTime)
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
        } else {
            fm.stopFasting()
        }

        if fm.isFasting {
            fastEndNotification.schedule(for: fm.currentGoalTime)
        } else {
            fastStartNotification.schedule(for: fm.nextfastingTime)
        }
        timer.start()
        saveState()
    }
        
    var fastingText: String {
        return fm.isFasting ? "Time fasting" : "Time since last fast"
    }
    
    var elapsed: TimeInterval {
        
        let startTime = fm.latestEndTime ?? fm.latestStartTime ?? Date()
    
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