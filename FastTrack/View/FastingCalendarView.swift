//
//  ModernFastingCalendarView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 13.4.2025.
//

import SwiftUI

struct FastingCalendarView: View {
    @ObservedObject var historyManager: FastHistoryManager

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let daySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        VStack(spacing: 12) {
            // Day headers
            HStack {
                ForEach(daySymbols, id: \.self) { day in
                    Text(day.prefix(1)) // Just the first letter (e.g., "M")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(daysInLastFourWeeks(), id: \.self) { date in
                    ZStack {
                        Circle()
                            .fill(getColorForDate(date).opacity(0.3))
                            .frame(width: 36, height: 36)

                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.footnote)
                            .foregroundColor(.primary)

                        if isToday(date: date) {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 2)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
        .padding()
    }

    // Utilities
    private func isToday(date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }

    private func daysInLastFourWeeks() -> [Date] {
        let today = Date()
        return (0..<28).compactMap { day in
            Calendar.current.date(byAdding: .day, value: -day, to: today)
        }.reversed()
    }

    private func getColorForDate(_ date: Date) -> Color {
        if let fast = historyManager.fastForDate(date) {
            return fast.isSuccessful ? .green : .yellow
        }
        return .gray
    }
}

#Preview {
    FastingCalendarView(historyManager: FastHistoryManager())
}
