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
        
        VStack(alignment: .trailing, spacing: 20) {
            
            HStack {
                Text("Started")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Button(formatDateToString(date: fast.startTime)){
                    self.showingDatePicker = true
                    editingDate = .startTime
                }
            }
            
            HStack {
                Text(fast.isFasting ? "Goal" : "Ended")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Button(formatDateToString(date: fast.isFasting ? fast.goalTime : fast.endTime)) {
                    self.showingDatePicker = true
                    editingDate = .endTime
                }.disabled(fast.endTime == nil)
            }
        }
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
