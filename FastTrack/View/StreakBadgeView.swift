//
//  StreakBadgeView.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 27.4.2025.
//

import SwiftUI

struct StreakBadgeView: View {
    let streakCount: Int

    var body: some View {
        HStack(spacing: 4) { // Reduced spacing
            ZStack {
                Capsule()
                    .fill(Color.accentColor) // Customize the badge color
                    .frame(width: 70, height: 40) // Adjust size for emoji and number

                HStack(spacing: 6) { // Space between emoji and number
                    Text("🔥")
                        .font(.title3)
                    Text("\(streakCount)")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    StreakBadgeView(streakCount: 10)
}
