//
//  FastTests.swift
//  FastTrackTests
//
//  Created by Francesco Balestrieri on 4.3.2024.
//

import XCTest
@testable import FastTrack

class FastTests: XCTestCase {
    
    func testFast_FastingWhenEndTimeIsNotNil() {
        let fast = Fast(startTime: Date(), endTime: Date())
        XCTAssertFalse(fast.isFasting, "Fasting should be false when endTime is not nil")
    }
    
    func testFast_FastingWhenOnlyStartTimeIsSet() {
        let fast = Fast(startTime: Date(), endTime: nil)
        XCTAssertTrue(fast.isFasting, "Fasting should be true when only startTime is set")
    }
        
    func testFast_SuccessfulWhenNotEnoughTimeHasPassed() {
        let now = Date()
        let fastingHours = 16
        let fast = Fast(startTime: now, endTime: now.addingTimeInterval(Double(fastingHours * 3600 - 1)), fastingHours: fastingHours)
        XCTAssertFalse(fast.successful, "Successful should be false when the fasting period is less than fastingHours")
    }
    
    func testFast_SuccessfulWhenEnoughTimeHasPassed() {
        let now = Date()
        let fastingHours = 16
        let fast = Fast(startTime: now, endTime: now.addingTimeInterval(Double(fastingHours * 3600)), fastingHours: fastingHours)
        XCTAssertTrue(fast.successful, "Successful should be true when the fasting period is equal to or greater than fastingHours")
    }
    
    func testFast_SuccessfulWhenEndTimeIsNil() {
        let now = Date()
        let fastingHours = 16
        let start = Calendar.current.date(byAdding: .hour, value: -fastingHours, to: now)!
        let fast = Fast(startTime: start, endTime: nil, fastingHours: fastingHours)
        XCTAssertTrue(fast.successful, "Successful should be true when the fasting period has surpassed fastingHours and endTime is nil")
    }
}
