//
//  FastsListView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 11.3.2024.
//

import SwiftUI

struct FastsListView: View {
    @ObservedObject var fastManager: FastManager

    var body: some View {
        List {
            ForEach(fastManager.fasts.reversed(), id: \.id) { fast in
                VStack(alignment: .leading) {
                    Text("Start Time: \(formatDate(fast.startTime))")
                    Text("End Time: \(fast.endTime != nil ? formatDate(fast.endTime!) : "Ongoing")")
                        .foregroundColor(fast.endTime != nil ? .black : .red)
                    Text("Duration: \(formatDuration(fast.duration))")
                }
            }
            .onDelete(perform: deleteFast)
        }
    }
    private func deleteFast(at offsets: IndexSet) {
        fastManager.fasts.remove(atOffsets: offsets)
        fastManager.save()
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
    var fm = FastManager()
    fm.startFasting()
    fm.stopFasting()
    fm.startFasting()
    fm.stopFasting()
    fm.startFasting()
    return FastsListView(fastManager: fm)
}
