//
//  DateTimePicker.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 26.4.2025.
//

import SwiftUI

struct DateTimePicker: View {

    @Binding var date: Date
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Adjust Time")
            DatePicker(
                "",
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            HStack {
                Button("Confirm") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    DateTimePicker(date: .constant(Date()))
}
