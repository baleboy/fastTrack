//
//  FastDatePickerView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 10.3.2024.
//

import SwiftUI

struct FastDatePickerView: View {
    @Binding var dateTime: Date
    var message = "Select Time"
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Text(message).font(.title)
        DatePicker(message, selection: $dateTime, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle()) // Use wheel style for explicit time picking
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
}

#Preview {
    FastDatePickerView(dateTime: .constant(Date()))
}
