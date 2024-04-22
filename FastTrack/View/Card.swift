//
//  Card.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 21.4.2024.
//

import SwiftUI

struct Card<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            content
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 2)
    }
}
#Preview {
    VStack(spacing: 10) {
        Card(title: "Card Title 1") {
            Text("Card Content 1")
        }
        
        Card(title: "Card Title 2") {
            Text("Card Content 2")
        }
    }.padding(10)
}
