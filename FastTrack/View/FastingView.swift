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
            Text(fastManager.isFasting ? "FASTING" : "NOT FASTING").font(.title)
            Text (fastingText).padding(10).font(.caption)
            Text(elapsedText)
                .font(.largeTitle.monospacedDigit())
            
            ProgressView(value: elapsed, total: fastManager.currentDuration)
            
            Group {
                if let _ = fastManager.latestFast {
                    EditableFastView(fast: Binding(
                        get: { self.fastManager.latestFast ?? Fast() },
                        set: { self.fastManager.updateLatestFast(with: $0) }
                    ))
                } else {
                    Text("Not fasted yet")
                }
            }
            
            Button(){
                toggleFasting()
            } label: {
                Text(fastManager.isFasting ? "Stop Fasting" : "Start Fasting")
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()
        }
        .padding(80)
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
