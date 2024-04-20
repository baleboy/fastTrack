//
//  CalendarView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 18.4.2024.
//

import SwiftUI

struct FastingCalendarView: View {
    
    @ObservedObject var fastManager: FastManager
    
    var body: some View {
        let dates = daysInLastFourWeeks()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(dates, id: \.self) { date in
                Text(date, formatter: itemFormatter)
                    .frame(width: 40, height: 40)
                    .background(getColorForDate(date).opacity(0.3))
                    .cornerRadius(5)
            }
        }
    }
    
    private func isToday(date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: today)
    }
    private var today: Date {
        Date()
    }

    private func daysInLastFourWeeks() -> [Date] {
        let dates = (0..<28).map { day -> Date in
            Calendar.current.date(byAdding: .day, value: -day, to: today )!
        }
        return dates.reversed()
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private func getColorForDate(_ date: Date) -> Color {
        if let fast = fastManager.fastForDate(date) {
            return fast.isSuccessful ? Color.green : Color.yellow
        }
        return Color.gray
    }
}

#Preview {
    FastingCalendarView(fastManager: FastManager())
}
