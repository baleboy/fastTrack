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
                
                Text(fastingText)
                Text(elapsedText)
                    .font(.largeTitle.monospacedDigit())
                
                ProgressView(value: elapsed, total: fastManager.currentDuration).padding(.horizontal, 30)
                
                Button(){
                    toggleFasting()
                } label: {
                    Text(fastManager.isFasting ? "Stop Fasting" : "Start Fasting")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                
                if let currentFast = fastManager.latestFast {
                    Text(currentFast.isFasting ? "Current Fast" : "Previous fast")
                    EditableFastView(fast: Binding(
                        get: { self.fastManager.latestFast ?? Fast() },
                        set: { self.fastManager.updateLatestFast(with: $0) }
                    )).padding(.horizontal, 80)
                }
                
                
                Spacer()
                Text("Last 4 weeks")
            
                FastingCalendarView(fastManager: fastManager)
                    .padding(10)
                
                
                
                
            }
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
