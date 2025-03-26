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
            Form {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(fastingText)
                            Text(elapsedText)
                                .font(.largeTitle.monospacedDigit())
                        }
                        Spacer()
                        EditableFastView(fast: Binding(
                            get: { self.fastManager.latestFast ?? Fast() },
                            set: { self.fastManager.updateLatestFast(with: $0) }))
                    }
                    ProgressView(value: elapsed, total: fastManager.currentDuration)
                        .progressViewStyle(LinearProgressViewStyle(tint: fastingColor)).padding()
                    
                    Button {
                        toggleFasting()
                    } label: {
                        Text(fastManager.isFasting ? "Stop Fasting" : "Start Fasting")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(fastingColor) // Changes color dynamically
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                Section {
                    StreakCounterView(fastManager: fastManager)
                }
                
                Section("Last 4 weeks"){
                    FastingCalendarView(fastManager: fastManager)
                        .padding(10)
                }

            }
        }
        .padding(10)
    }
    
    var fastingText: String {
        return fastManager.isFasting ? "Time fasting" : "Time since fast"
    }
    
    var fastingColor: Color {
        fastManager.isFasting ? Color.purple : Color.blue
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
