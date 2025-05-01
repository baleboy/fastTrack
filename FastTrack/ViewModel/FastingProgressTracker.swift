//
//  FastingManager.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 24.4.2025.
//

import SwiftUI
import Combine

class FastingProgressTracker: ObservableObject {

    @Published private(set) var timeFasting: TimeInterval = 0
    @Published private(set)var timeNotFasting: TimeInterval = 0
    @Published private(set)var isFasting: Bool = false
    
    @Published private(set)var fastingStartTime: Date?
    @Published private(set) var fastingEndTime: Date?

    var historyManager: FastHistoryManager = FastHistoryManager()
    var fastDuration: TimeInterval = 16 * 60 * 60
    
    private var notificationManager = FastingNotificationManager()
    
    init() {
        print("loading state")
        loadState()
        if !neverFasted {
            startTimerPublisher()
        }
    }
    
    var fastingGoalTime: Date? {
        if let startTime = fastingStartTime {
            return Calendar.current.date(
                byAdding: .second, value: Int(fastDuration), to: startTime)
        }
        return nil
    }
    
    var nextFastingTime: Date? {
        if let endTime = fastingEndTime {
            let eatingDuration = 24 * 60 * 60 - fastDuration
            return Calendar.current.date(
                byAdding: .second, value: Int(eatingDuration), to: endTime)
        }
        return nil
    }
    
    var neverFasted: Bool {
        return fastingStartTime == nil
    }
        
    func startedFasting(at dateTime: Date = Date()) {
        
        stopTimerPublisher()
        
        fastingStartTime = dateTime
        timeNotFasting = 0
        fastingEndTime = nil
        isFasting = true
        updateElapsedTime(until: Date.now)
        saveState()
        notificationManager.scheduleFastEndNotification(for: fastingGoalTime)
        startTimerPublisher()
    }
    
    func stoppedFasting(at dateTime: Date = Date()) {
        stopTimerPublisher()
        
        if let startTime = fastingStartTime {
            historyManager.append(Fast(startTime: startTime, endTime: dateTime))
        }
        
        fastingEndTime = dateTime
        isFasting = false
        timeFasting = 0
        updateElapsedTime(until: Date.now)
        saveState()
        notificationManager.scheduleFastStartNotification(for: nextFastingTime)
        startTimerPublisher()
    }
    
    func updateFastingStartTime(_ dateTime: Date) {
        fastingStartTime = dateTime
        saveState()
        notificationManager.scheduleFastEndNotification(for: fastingGoalTime)
    }
    
    func updateFastingEndTime(_ dateTime: Date) {
        fastingEndTime = dateTime
        saveState()
        notificationManager.scheduleFastStartNotification(for: nextFastingTime)
    }
    
    func toggledFasting(at dateTime: Date = Date()) {
        isFasting ? stoppedFasting(at: dateTime) : startedFasting(at: dateTime)
    }
    
    var timeFastingText: String {
        return formatTimeInterval(timeFasting)
    }
    
    var timeNotFastingText: String {
        return formatTimeInterval(timeNotFasting)
    }
    
    // MARK: - Implementation
    
    private var timerSubscription: Cancellable?
    
    private func startTimerPublisher() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] emittedDate in
                guard let self = self else { return }
                updateElapsedTime(until: emittedDate)
            }
    }

    private func updateElapsedTime(until dateTime: Date) {
        if self.isFasting, let startTime = self.fastingStartTime {
            timeFasting = dateTime.timeIntervalSince(startTime)
        }
        else if let endTime = self.fastingEndTime {
            timeNotFasting = dateTime.timeIntervalSince(endTime)
        }
    }
    
    private func stopTimerPublisher() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "--:--:--"
    }
    
    static func testObject() -> FastingProgressTracker {
        let tracker = FastingProgressTracker()
        tracker.startedFasting()
        tracker.stoppedFasting()
        return tracker
    }
    
    // MARK: - Persistence

    private let stateKey = "fastingState"
    
    private func loadState() {
        if let savedData = UserDefaults.standard.data(forKey: stateKey) {
            if let loadedState = try? JSONDecoder().decode(FastingState.self, from: savedData) {
                timeFasting = loadedState.timeFasting
                timeNotFasting = loadedState.timeNotFasting
                isFasting = loadedState.isFasting
                fastingStartTime = loadedState.fastingStartTime
                fastingEndTime = loadedState.fastingEndTime
            }
        }
    }

    private func saveState() {
        let state = FastingState(
            timeFasting: timeFasting,
            timeNotFasting: timeNotFasting,
            isFasting: isFasting,
            fastingStartTime: fastingStartTime,
            fastingEndTime: fastingEndTime
        )
        if let encodedData = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encodedData, forKey: stateKey)
        }
    }
    
    // MARK: - Timer Visibility Control

    func timerIsVisible() {
        print("Timer is visible - starting timer if needed")
        if isFasting || fastingEndTime != nil {
            startTimerPublisher()
        }
    }

    func timerIsNotVisible() {
        print("Timer is not visible - stopping timer")
        stopTimerPublisher()
    }
}

// Helper struct to hold the fasting state
struct FastingState: Codable {
    var timeFasting: TimeInterval = 0
    var timeNotFasting: TimeInterval = 0
    var isFasting: Bool = false
    var fastingStartTime: Date?
    var fastingEndTime: Date?
}

