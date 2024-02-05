//
//  Fast.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 3.2.2024.
//

import SwiftUI

class Fast: ObservableObject, Codable {
    @Published var startTime: Date?
    @Published var endTime: Date?

    var fasting: Bool {
        if startTime == nil || endTime != nil {
            return false
        }
        return true
    }
    
    func toggle() {

        if fasting {
            endTime = Date()
        } else {
            startTime = Date()
            endTime = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
    }
    
    required init() {
        // do nothing
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encodedTimer = try? encoder.encode(self) {
            UserDefaults.standard.set(encodedTimer, forKey: "fastData")
        }
    }
    
    static func load() -> Fast {

        let loadedFast: Fast
        
        if let fastData = UserDefaults.standard.data(forKey: "fastData") {
            let decoder = JSONDecoder()
            if let fast = try? decoder.decode(Fast.self, from: fastData) {
                loadedFast = fast
            } else {
                loadedFast = Fast()
            }
        } else {
            loadedFast = Fast()
        }
        return loadedFast
    }

}
