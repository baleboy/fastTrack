//
//  FastHistoryManager.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 26.4.2025.
//

import SwiftUI

class FastHistoryManager: ObservableObject {
    @Published var history: [Fast2] = []{
        didSet {
            saveHistory()
        }
    }
    
    init() {
        print("loading history")
        loadHistory()
    }
    
    func append(_ item: Fast2) {
        objectWillChange.send()
        history.append(item)
    }
    
    func fastForDate(_ date: Date) -> Fast2? {
        for fast in history {
            if Calendar.current.isDate(fast.endTime ?? Date(), inSameDayAs: date) {
                return fast
            }
        }
        return nil
    }
    
    func fastsForDate(_ date: Date) -> [Fast2] {
        return history.filter { fast in
            if let endTime = fast.endTime {
                return Calendar.current.isDate(endTime, inSameDayAs: date)
            }
            return false
        }
    }
    
    var streak: Int {
        var streak = 0
        let calendar = Calendar.current
        let now = Date()
        let maxHoursBetweenFasts: Int = 24
        
        for i in 0..<history.count {
            
            if i == 0 {
                // Special case for the most recent fast: Check if it ended more than `maxHoursBetweenFasts` ago
                if let lastFastEndTime = history[i].endTime, let hoursSinceLastFast = calendar.dateComponents([.hour], from: lastFastEndTime, to: now).hour, hoursSinceLastFast > maxHoursBetweenFasts {
                    break // If the last fast ended more than `maxHoursBetweenFasts` hours ago, streak is broken immediately
                }
            }
            
            if history[i].isSuccessful {
                if i > 0 {
                    // Calculate the time difference in hours between the start of the current fast and the end of the previous fast
                    let calendar = Calendar.current
                    let dateComponents = calendar.dateComponents([.hour], from: history[i].endTime!, to: history[i-1].startTime)
                    if let hour = dateComponents.hour, hour > maxHoursBetweenFasts {
                        break // More than allowed hours have passed, streak ends
                    }
                }
                streak += 1 // Increment the streak for a successful fast within the allowed time
            } else if !history[i].isFasting {
                break
            }
        }
        return streak
    }
    
    // MARK: - Persistence
    
    private let historyKey = "fastingHistory"
    
    private func loadHistory() {
        if let savedData = UserDefaults.standard.data(forKey: historyKey) {
            if let loadedHistory = try? JSONDecoder().decode([Fast2].self, from: savedData) {
                history = loadedHistory
            }
        }
    }

    private func saveHistory() {
        if let encodedData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        }
    }
}
