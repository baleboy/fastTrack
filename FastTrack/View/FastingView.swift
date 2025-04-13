import SwiftUI

struct FastingView: View {
    @ObservedObject var fastManager: FastManager
    @ObservedObject var timer: StopWatchTimer
    var toggleFasting: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🔥 Streak
                if fastManager.streak > 0 {
                    StreakCounterView(fastManager: fastManager)
                        .padding(.top)
                }
                
                // ⏱ Timer Card
                Card {
                FastingTimerCard(
                    isFasting: fastManager.isFasting,
                    elapsedText: elapsedText,
                    duration: fastManager.currentDuration,
                    elapsed: elapsed,
                    onToggle: toggleFasting
                )
                }
                // ✍️ Editable Fast Card
                if let currentFast = fastManager.latestFast {
                    Card(title: currentFast.isFasting ? "Current Fast" : "Previous Fast") {
                        ModernEditableFastView(fast: Binding(
                            get: { fastManager.latestFast ?? Fast() },
                            set: { fastManager.updateLatestFast(with: $0) }
                        ))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }

                // 📅 Calendar
                Card(title: "Last 4 Weeks") {
                    ModernFastingCalendarView(fastManager: fastManager)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground)) // 👈 light gray
        // .edgesIgnoringSafeArea(.all) // optional
    }

    // MARK: - Helpers

    var elapsed: TimeInterval {
        let start = fastManager.latestEndTime ?? fastManager.latestStartTime ?? Date()
        return Date().timeIntervalSince(start)
    }

    var elapsedText: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: elapsed) ?? "--:--"
    }
}

#Preview {
    FastingView(fastManager: FastManager(), timer: StopWatchTimer()) {
        print("Toggle fast")
    }
}

