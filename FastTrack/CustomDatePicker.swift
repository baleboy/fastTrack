//
//  FastTimeEditor.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 9.2.2024.
//

import SwiftUI


struct CustomDatePicker: View {
    
    enum Selection {
        case start
        case end
    }

    var selection = Selection.start
    @Binding var startTime: Date?
    @Binding var endTime: Date?
    @Binding var showingDatePicker: Bool
    
    var body: some View {
        VStack {
            if selection == .start {
                DatePicker("Select Start Time", selection: Binding($startTime)!, displayedComponents: .hourAndMinute)
            } else {
                DatePicker("Select End Time", selection: Binding($endTime)!, displayedComponents: .hourAndMinute)
            }
            Button {
                showingDatePicker = false
            } label: {
                Text("Done")
            }.buttonStyle(.borderedProminent)
            .padding()
        }
        .datePickerStyle(GraphicalDatePickerStyle())
        .padding()   
    }
}

#Preview {
    CustomDatePicker(
        startTime: .constant(Date()),
        endTime: .constant(Date()),
        showingDatePicker: .constant(true))
    .padding()
}
