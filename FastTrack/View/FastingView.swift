//
//  FastingView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 14.3.2024.
//

import SwiftUI

struct FastingView: View {
    
    @ObservedObject var fastManager: FastManager
    @ObservedObject var timer: StopWatchTimer
    var toggleFasting: () -> Void
    
    var body: some View {
        VStack {
            StreakCounterView(fastManager: fastManager)
            Spacer()
            VStack(spacing: 20) {
                Card(title: fastingText) {
                    VStack {
                        Text(elapsedText)
                            .font(.largeTitle.monospacedDigit())
                        
                        if fastManager.isFasting { ProgressView(value: elapsed, total: fastManager.currentDuration)
                        }
                        
                        Button(){
                            toggleFasting()
                        } label: {
                            Text(fastManager.isFasting ? "Stop Fasting" : "Start Fasting")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                
                if let currentFast = fastManager.latestFast {
                    Card(title: currentFast.isFasting ? "Current Fast" : "Previous fast") {
                        VStack {
                                EditableFastView(fast: Binding(
                                    get: { self.fastManager.latestFast ?? Fast() },
                                    set: { self.fastManager.updateLatestFast(with: $0) }
                                )).padding(.horizontal, 80)
                            }
                        .padding(.vertical, 20)
                        }
                    }
                
                Card(title: "Last 4 weeks") { FastingCalendarView(fastManager: fastManager)
                        .padding(10)
                    }
                }
            
            Spacer()
        }
        .padding(10)
    }
    
    var fastingText: String {
        return fastManager.isFasting ? "Time fasting" : "Time since last fast"
    }
    
    var elapsed: TimeInterval {
        
        let startTime = fastManager.latestEndTime ?? fastManager.latestStartTime ?? Date()
    
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
}

#Preview {
    
    FastingView(fastManager: FastManager(), timer: StopWatchTimer()) {
        print("button pressed")
    }
}
