//
//  ModernEditableFastView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 13.4.2025.
//

import SwiftUI

struct CurrentFastView: View {
    @ObservedObject var fastTracker: FastingProgressTracker

    @State private var showingDatePicker = false
    @State private var pickedDate = Date()
    
    @State private var editingDateType: EditingDate?

    enum EditingDate {
        case start
        case end
    }

    var body: some View {
            HStack(spacing: 16) {
                timeTile(title: "Started", date: fastTracker.fastingStartTime) {
                    pickedDate = fastTracker.fastingStartTime!
                    editingDateType = .start
                    showingDatePicker = true
                }
                
                timeTile(
                    title: fastTracker.isFasting ? "Goal" : "Ended",
                    date: fastTracker.isFasting ? fastTracker.fastingGoalTime : fastTracker.fastingEndTime,
                    disabled: fastTracker.isFasting
                ) {
                    editingDateType = .end
                    pickedDate = fastTracker.fastingEndTime!
                    showingDatePicker = true
                }
            }
        .padding()
        .sheet(isPresented: $showingDatePicker, onDismiss: storePickedDate) {
            DateTimePicker(date: $pickedDate).presentationDetents([.medium])
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
        }
        .disabled(disabled)
    }
    
    func storePickedDate() {
        if let dateType = editingDateType {
            switch dateType {
            case .start:
                fastTracker.updateFastingStartTime(pickedDate)
            case .end:
                fastTracker.updateFastingEndTime(pickedDate)
            }
        }
    }

    func formatDateToString(date: Date?) -> String {
        guard let validDate = date else { return "--:--" }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: validDate)
    }
}

#Preview {
    CurrentFastView(fastTracker: FastingProgressTracker.testObject())
        .padding()
}
