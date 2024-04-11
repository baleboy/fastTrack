//
//  FastManager.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 29.2.2024.
//

import Foundation

class FastManager: ObservableObject {
    
    @Published var fasts = [Fast]()
    
    let userDefaults: UserDefaults
    var fastingHours = 16
    var maxHoursBetweenFasts = 24
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var latestFast: Fast? {
        return fasts.first
    }
    
    func updateLatestFast(with fast: Fast) {
        if !fasts.isEmpty {
            fasts[0] = fast
        } else {
            fasts.append(fast)
        }
    }
        
    var isFasting: Bool {
        return latestFast?.isFasting ?? false
    }

    var neverFasted: Bool {
        return fasts.isEmpty
    }
    
    var fastingDuration: Double {
        return Double(fastingHours * 3600)
    }
    
    var eatingDuration: Double {
        return Double((24 - fastingHours) * 3600)
    }
    
    var currentDuration: Double {
        return isFasting ? fastingDuration : eatingDuration
    }
    
    var latestStartTime: Date? {
        return latestFast?.startTime
    }
    
    var latestEndTime: Date? {
        return latestFast?.endTime
    }
    
    var currentGoalTime: Date? {
        if isFasting {
            return latestFast?.goalTime
        }
        return nil
    }
    
    var nextfastingTime: Date? {

        if isFasting {
            return nil
        }
        
        if let endTime = latestFast?.endTime {
            return Calendar.current.date(
                byAdding: .hour, value: 24 - fastingHours, to: endTime) ?? Date()
        }
        
        return nil
    }
    
    var streak: Int {
        var streak = 0
        let calendar = Calendar.current
        let now = Date()
        
        for i in 0..<fasts.count {
            
            if i == 0 {
                // Special case for the most recent fast: Check if it ended more than `maxHoursBetweenFasts` ago
                if let lastFastEndTime = fasts[i].endTime, let hoursSinceLastFast = calendar.dateComponents([.hour], from: lastFastEndTime, to: now).hour, hoursSinceLastFast > maxHoursBetweenFasts {
                    break // If the last fast ended more than `maxHoursBetweenFasts` hours ago, streak is broken immediately
                }
            }
            
            if fasts[i].isSuccessful {
                if i > 0 {
                    // Calculate the time difference in hours between the start of the current fast and the end of the previous fast
                    let calendar = Calendar.current
                    let dateComponents = calendar.dateComponents([.hour], from: fasts[i].endTime!, to: fasts[i-1].startTime)
                    if let hour = dateComponents.hour, hour > maxHoursBetweenFasts {
                        break // More than allowed hours have passed, streak ends
                    }
                }
                streak += 1 // Increment the streak for a successful fast within the allowed time
            } else if !fasts[i].isFasting {
                break
            }
        }
        return streak
    }

    func startFasting() {
        fasts.insert(Fast(startTime: Date()), at:0)
    }
    
    func stopFasting() {
        if let fast = latestFast {
            fast.endTime = Date()
            fasts[0] = fast // This reassignment helps SwiftUI detect the change.
        }
    }
        
    func save() {
        let encoder = JSONEncoder()
        
        do {
            let encodedArray = try encoder.encode(fasts)
            UserDefaults.standard.set(encodedArray, forKey: "fasts")
         } catch {
             print("Error encoding fastManager data: \(error)")
         }
    }
    
    func loadCompletedFasts() -> [Fast] {
        guard let encodedData = userDefaults.data(forKey: "fasts") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedFasts = try decoder.decode([Fast].self, from: encodedData)
            return decodedFasts
        } catch {
            print("Error decoding completed fasts: \(error)")
            return []
        }
    }
    
    func load() {
        fasts = loadCompletedFasts()
    }
    
}
