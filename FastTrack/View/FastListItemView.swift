//
//  FastListItemView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 29.3.2024.
//

import SwiftUI

struct FastListItemView: View {
    var fast: Fast
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Start Time: \(formatDate(fast.startTime))")
                Text("End Time: \(formatDate(fast.endTime!))")
                Text("Duration: \(formatDuration(fast.duration))")
            }
            Spacer() // This pushes the checkmark to the right
            Image(systemName: fast.isSuccessful ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(fast.isSuccessful ? .green : .red)

        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }
}

#Preview {
    FastListItemView(fast: Fast(startTime: Date(), endTime: Date()))
}
