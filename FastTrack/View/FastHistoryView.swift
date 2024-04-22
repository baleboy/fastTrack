//
//  FastsListView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 11.3.2024.
//

import SwiftUI

struct FastHistoryView: View {
    @ObservedObject var fastManager: FastManager

    var body: some View {
        if fastManager.fasts.isEmpty {
            Text("No completed fasts")
                .font(.title)
                .foregroundColor(.gray)
        } else {
            NavigationView {
                VStack {
                    Card(title: "Last 4 weeks") { FastingCalendarView(fastManager: fastManager)
                            .padding(10)
                    }
                    Spacer()
                }
                .navigationTitle("Fast History")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    var fm = FastManager()
    fm.startFasting()
    fm.stopFasting()
    fm.startFasting()
    fm.stopFasting()
    fm.startFasting()
    return FastHistoryView(fastManager: fm)
}
