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
        List(fastManager.fasts, id: \.id) { fast in
            VStack(alignment: .leading) {
                Text("Start Time: \(formatDate(fast.startTime))")
                Text("End Time: \(fast.endTime != nil ? formatDate(fast.endTime!) : "Ongoing")")
                    .foregroundColor(fast.endTime != nil ? .black : .red)
                Text("Status: \(fast.isFasting ? "Fasting" : "Not Fasting")")
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    var fm = FastManager()
    fm.startFasting()
    fm.stopFasting()
    fm.startFasting()
    fm.stopFasting()
    return FastsListView(fastManager: fm)
}
