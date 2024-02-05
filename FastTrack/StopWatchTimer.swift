//
//  FastingTimer.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 21.1.2024.
//

import Foundation
import SwiftUI

class StopWatchTimer : ObservableObject, Codable {
    
    @Published var startTime: Date?
    
    var elapsed: TimeInterval {
        guard let startTime = startTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    private var timer: Timer?
    
    enum CodingKeys: String, CodingKey {
        case startTime
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        // Initialize the timer based on the decoded startTime
        if startTime != nil {
            resume()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
    }

    // Required initializer for Codable
    required init() {
        // Nothing to do
    }
        
    // Reset and start the timer
    func start() {
        startTime = Date.now // resets elapsed time to 0
        timer?.invalidate()
        self.resume()
    }
    
    // Stop the timer withtout resetting it
    func stop() {
        timer?.invalidate()
        // stop doesn't reset the timer
    }
    
    // Resume the timer. The elapsed time will be calculated from the time start() was called
    func resume() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encodedTimer = try? encoder.encode(self) {
            UserDefaults.standard.set(encodedTimer, forKey: "timerData")
        }
    }
    
    static func load() -> StopWatchTimer {
        // Restore timer object
        let loadedTimer: StopWatchTimer
        
        if let timerData = UserDefaults.standard.data(forKey: "timerData") {
            let decoder = JSONDecoder()
            if let timer = try? decoder.decode(StopWatchTimer.self, from: timerData) {
                loadedTimer = timer
            } else {
                loadedTimer = StopWatchTimer()
            }
        } else {
            loadedTimer = StopWatchTimer()
        }
        return loadedTimer
    }
}
    
