//
//  ContentView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 17.1.2024.
//

import SwiftUI
import UserNotifications

struct FastTrackView: View {

    @StateObject var fastingManager = FastingProgressTracker()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Card {
                    VStack {
                        FastingTimerView(fastingTracker: fastingManager)
                        if (fastingManager.isFasting) {
                            CurrentFastView(fastTracker: fastingManager)
                        }
                    }
                }
                Card {
                    FastingCalendarView(historyManager: fastingManager.historyManager)
                }
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if fastingManager.historyManager.streak > 0 {
                        StreakBadgeView(streakCount: fastingManager.historyManager.streak)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("FastTrack") // Centered title (optional, if you still want it centered)
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    FastTrackView(fastingManager: FastingProgressTracker())
}
