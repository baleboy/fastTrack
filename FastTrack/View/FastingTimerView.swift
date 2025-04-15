//
//  FastingTimerCard.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 13.4.2025.
//

import SwiftUI

struct FastingTimerView: View {
    let isFasting: Bool
    let elapsedText: String
    let duration: TimeInterval
    let elapsed: TimeInterval
    let onToggle: () -> Void

    var body: some View {
            VStack(spacing: 20) {
                Text(isFasting ? "Time Fasting" : "Time Since Last Fast")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            
                Text(elapsedText)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                    Text("Goal: \(Int(duration / 3600))h")
                        .font(.caption)
                        .foregroundColor(.secondary)
                
                
                Divider()
                
                Button(action: onToggle) {
                    Label(isFasting ? "Stop Fasting" : "Start Fasting", systemImage: isFasting ? "pause.fill" : "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(isFasting ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
                .animation(.easeInOut, value: isFasting)
            }
            .padding()
        }
        //.background(Color(.systemBackground))
        //.cornerRadius(20)
        //.shadow(radius: 4)
        //.padding(.horizontal)
}

#Preview {
    FastingTimerView(
        isFasting: true,
        elapsedText: "03:42:10",
        duration: 16 * 3600,
        elapsed: 3.7 * 3600,
        onToggle: { print("Toggled") }
    )
}
