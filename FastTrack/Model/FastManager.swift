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
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var latestFast: Fast? {
        return fasts.last
    }
    
    func updateLatestFast(with fast: Fast) {
        if !fasts.isEmpty {
            fasts[fasts.count - 1] = fast
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
        for fast in fasts.reversed() {
            if fast.isSuccessful {
                streak += 1
            } else if !fast.isFasting {
                break
            }
        }
        return streak
    }

    func startFasting() {
        fasts.append(Fast(startTime: Date()))
    }
    
    func stopFasting() {
        if let fast = latestFast {
            fast.endTime = Date()
            fasts[fasts.count - 1] = fast // This reassignment helps SwiftUI detect the change.
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
