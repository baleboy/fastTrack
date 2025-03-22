//
//  FastView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 9.3.2024.
//

import SwiftUI

enum EditingDate {
    case startTime
    case endTime
    case none
}

struct EditableFastView: View {
    
    @Binding var fast: Fast
    
    @State private var showingDatePicker = false
    @State private var editingDate: EditingDate = .none
    
    var body: some View {
        
        HStack(spacing: 20) {
            DateView(date: fast.startTime)
            Button {
                self.showingDatePicker = true
                editingDate = .startTime
            } label: {
                VStack {
                    Text("Started")
                    Text(formatDateToString(date: fast.startTime))
                }
            }
            Spacer()
            Button {
                self.showingDatePicker = true
                editingDate = .endTime
            } label: {
                VStack {
                    Text(fast.isFasting ? "Goal" : "Ended")
                    Text(formatDateToString(date: fast.isFasting ? fast.goalTime : fast.endTime))
                }
            }.disabled(fast.endTime == nil)
        }
        .padding(10)
            .sheet(isPresented: $showingDatePicker) {
                if editingDate == .startTime {
                    FastDatePickerView(dateTime: $fast.startTime, message: "Select Start Time")
                }
                else {
                    // Bindings and optionals don't go well together
                    if let date = fast.endTime {
                        FastDatePickerView(dateTime: Binding(
                            get: { date },
                            set: { fast.endTime = $0 }
                        ), message: "Select End Time")
                    } else {
                        Text("Error - endDate is nil")
                    }
                }
            }
        
    }
    
    func formatDateToString(date: Date?) -> String {
        guard let validDate = date else {
            return "—:—"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: validDate)
    }
}

#Preview {
    EditableFastView(fast: .constant(Fast()))
    // Date().addingTimeInterval(3600))))
}
