//
//  StreakCounterView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 30.3.2024.
//

import SwiftUI

struct StreakCounterView: View {
    @ObservedObject var fastManager: FastManager
    var body: some View {
        if fastManager.streak > 0 {
            Text("Streak: \(fastManager.streak) 🔥")
        }
    }
}

#Preview {
    StreakCounterView(fastManager: FastManager())
}
