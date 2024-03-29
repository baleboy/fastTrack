//
//  FastListItem.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 29.3.2024.
//

import SwiftUI

struct FastListItem: View {
    var fast: Fast
    var body: some View {
        VStack(alignment: .leading) {
            Text("Start Time: \(formatDate(fast.startTime))")
            Text("End Time: \(formatDate(fast.endTime!))")
            Text("Duration: \(formatDuration(fast.duration))")
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
    FastListItem(fast: Fast(startTime: Date(), endTime: Date()))
}
