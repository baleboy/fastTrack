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
                    StreakCounterView(fastManager: fastManager)
                    List {
                        ForEach(fastManager.fasts.filter { $0.endTime != nil }, id: \.id) { fast in
                            FastListItem(fast: fast)
                        }
                        .onDelete(perform: deleteFast)
                    }
                }
                .navigationTitle("Completed Fasts")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    private func deleteFast(at offsets: IndexSet) {
        fastManager.fasts.remove(atOffsets: offsets)
        fastManager.save()
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
