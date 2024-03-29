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
        NavigationView {
            if fastManager.fasts.isEmpty {
                Text("No completed fasts")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(fastManager.fasts.reversed().filter { $0.endTime != nil }, id: \.id) { fast in
                        FastListItem(fast: fast)
                    }
                    .onDelete(perform: deleteFast)
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
    return FastsListView(fastManager: fm)
}
