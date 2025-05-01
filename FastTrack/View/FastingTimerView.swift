//
//  FastingTimerCard.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 13.4.2025.
//

import SwiftUI

struct FastingTimerView: View {
    @ObservedObject var fastingTracker: FastingProgressTracker
    @State private var pickedDate = Date()
    @State private var showSheet: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 20) {
            heading
            timerTextView
            goalTextView
            Divider()
            fastingButton
        }
        .padding()
        .sheet(isPresented: $showSheet, onDismiss: timeConfirmed) {
            DateTimePicker(date: $pickedDate).presentationDetents([.medium])
        }
        .onAppear {
            print("FastingTimerView2 appeared")
            fastingTracker.timerIsVisible()
        }
        .onDisappear {
            print("FastingTimerView2 disappeared")
            fastingTracker.timerIsNotVisible()
        }
        .onChange(of: scenePhase) {
            print("Scene Phase changed to: \(scenePhase)")
            switch scenePhase {
            case .active:
                fastingTracker.timerIsVisible()
            case .inactive:
                fastingTracker.timerIsNotVisible()
            case .background:
                fastingTracker.timerIsNotVisible()
                // Optionally, schedule a local notification
            @unknown default:
                print("Unhandled scene phase")
            }
        }
    }
    
    // MARK: - UI components
    
    var heading: some View {
        Text(fastingTracker.isFasting ? "Time Fasting" : "Time Since Last Fast")
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.secondary)
    }
    
    var timerTextView: some View {
        Text(fastingTracker.isFasting ? fastingTracker.timeFastingText : fastingTracker.timeNotFastingText)
            .font(.system(size: 48, weight: .bold, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var goalTextView: some View {
        Text("Fasting goal: \(Int(fastingTracker.fastDuration / 3600))h")
                .font(.caption)
                .foregroundColor(.secondary)
    }
    
    var fastingButton: some View {
        Button(action: askToConfirmTime) {
            Label(fastingTracker.isFasting ? "Stop Fasting" : "Start Fasting", systemImage: fastingTracker.isFasting ? "pause.fill" : "play.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(fastingTracker.isFasting ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(12)
        .animation(.easeInOut, value: fastingTracker.isFasting)
    }
    
    private func askToConfirmTime() {
        pickedDate = Date()
        showSheet = true
    }
    
    private func timeConfirmed() {
        fastingTracker.toggledFasting(at: pickedDate)
    }
}

#Preview {
    FastingTimerView(fastingTracker: .testObject())
}
