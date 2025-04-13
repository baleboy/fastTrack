//
//  ModernEditableFastView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 13.4.2025.
//

import SwiftUI

struct ModernEditableFastView: View {
    @Binding var fast: Fast

    @State private var showingDatePicker = false
    @State private var editingDate: EditingDate = .none

    var body: some View {
        HStack(spacing: 16) {
            timeTile(title: "Started", date: fast.startTime) {
                editingDate = .startTime
                showingDatePicker = true
            }

            timeTile(
                title: fast.isFasting ? "Goal" : "Ended",
                date: fast.isFasting ? fast.goalTime : fast.endTime,
                disabled: fast.endTime == nil
            ) {
                editingDate = .endTime
                showingDatePicker = true
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            if editingDate == .startTime {
                FastDatePickerView(dateTime: $fast.startTime, message: "Edit Start Time")
            } else if editingDate == .endTime, let date = fast.endTime {
                FastDatePickerView(dateTime: Binding(
                    get: { date },
                    set: { fast.endTime = $0 }
                ), message: "Edit End Time")
            } else {
                Text("End time is not available")
                    .font(.headline)
                    .padding()
            }
        }
    }

    // MARK: - Time Tile

    func timeTile(title: String, date: Date?, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: {
            if !disabled { action() }
        }) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(formatDateToString(date: date))
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(disabled ? .gray : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .disabled(disabled)
    }

    func formatDateToString(date: Date?) -> String {
        guard let validDate = date else { return "--:--" }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: validDate)
    }
}

#Preview {
    ModernEditableFastView(fast: .constant(Fast()))
        .padding()
}
