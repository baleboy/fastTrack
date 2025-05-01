//
//  Fast.swift
//  FastTrack
//
//  Created by Francesco Balestrieri on 3.2.2024.
//

import Foundation

struct Fast2: Codable, Identifiable {

    static let defaultFastingHours = 16

    var id = UUID()
    
    var startTime: Date
    var endTime: Date?

    var fastingHours: Int
    
    var isFasting: Bool {
        return endTime == nil
    }
    
    var isSuccessful: Bool {
        return duration >= Double(fastingHours * 3600)
    }
    
    var duration: TimeInterval {
        return (endTime ?? Date()).timeIntervalSince(startTime)
    }
    
    var goalTime: Date? {
        return Calendar.current.date(
            byAdding: .hour, value: fastingHours, to: startTime) ?? nil
    }

    mutating func start() {
        startTime = Date()
        endTime = nil
    }

    mutating func stop() {
        endTime = Date()
    }

    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
        case fastingHours
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(fastingHours, forKey: .fastingHours)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date?.self, forKey: .endTime)
        fastingHours = try container.decode(Int.self, forKey: .fastingHours)
    }
    
    init(startTime: Date = Date(), endTime: Date? = nil, fastingHours: Int = defaultFastingHours) {
        self.startTime = startTime
        self.endTime = endTime
        self.fastingHours = fastingHours
    }
}
