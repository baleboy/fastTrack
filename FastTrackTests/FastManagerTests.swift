//
//  FastTrackTests.swift
//  FastTrackTests
//
//  Created by Francesco Balestrieri on 1.3.2024.
//

@testable import FastTrack

import XCTest

final class FastManagerTests: XCTestCase {

    var fastManager: FastManager!
    var testUserDefaults: UserDefaults!
    let testDomain = "com.fastTrack.tests"
    let calendar = Calendar.current
    var now: Date!
    
    override func setUp() {
        super.setUp()
        testUserDefaults = UserDefaults(suiteName: testDomain)
        fastManager = FastManager(userDefaults: testUserDefaults)
        now = Date()
    }

    override func tearDown() {
        super.tearDown()
        testUserDefaults.removePersistentDomain(forName: testDomain)
        fastManager = nil
    }

    func testFastManager_checkDefaultValuesAfterCreation() {
    
        let defaultFastingHours = 16
        
        XCTAssertFalse(fastManager.isFasting)
        XCTAssertEqual(fastManager.fastingHours, defaultFastingHours)
        XCTAssertTrue(fastManager.neverFasted)
    }
    
    func testFastManager_checkValuesAfterStartFasting() {
        
        fastManager.startFasting()
        
        XCTAssertTrue(fastManager.isFasting)
        XCTAssertFalse(fastManager.neverFasted)
    }
    
    func testFastManager_checkValuesAfterEndFasting() {

        fastManager.startFasting()
        fastManager.stopFasting()
        
        XCTAssertFalse(fastManager.isFasting)
    }
    
    func testFastManager_checkFastingAndEatingDuration() {

        fastManager.fastingHours = 10
        let expectedFastingDuration = Double(10 * 3600)
        let expectedEatingDuration = Double((24 - 10) * 3600)
        
        XCTAssertEqual(fastManager.fastingDuration, expectedFastingDuration)
        XCTAssertEqual(fastManager.eatingDuration, expectedEatingDuration)
    }

    func testFastManager_checkCompletedFastListWhenNotFasting() {
        
        fastManager.startFasting()
        fastManager.stopFasting()
        fastManager.startFasting()
        fastManager.stopFasting()
        fastManager.startFasting()
        fastManager.stopFasting()
        
        XCTAssertEqual(fastManager.fasts.count, 3)
    }
    
    func testFastManager_checkCompletedFastListWhenFasting() {
        
        fastManager.startFasting()
        fastManager.stopFasting()
        fastManager.startFasting()
        fastManager.stopFasting()
        fastManager.startFasting()
        
        XCTAssertEqual(fastManager.fasts.count, 3)
    }

    func testFastManager_checkPlannedEndTime() {
        
        fastManager.startFasting()
        
        XCTAssertEqual(fastManager.currentGoalTime, fastManager.latestFast?.startTime.addingTimeInterval(fastManager.fastingDuration))
    }
    
    func testFastManager_checkPlannedEndTimeNil() {
        
        fastManager.startFasting()
        fastManager.stopFasting()
        
        XCTAssertNil(fastManager.currentGoalTime)
    }

    
    func testFastManager_checkPlannedStartTime() {
        
        fastManager.startFasting()
        fastManager.stopFasting()
        
        XCTAssertEqual(fastManager.nextfastingTime, fastManager.fasts.first?.endTime?.addingTimeInterval(fastManager.eatingDuration))

    }
    
    func testFastManager_checkPlannedStartTimeNil() {
        
        fastManager.startFasting()
        
        XCTAssertNil(fastManager.nextfastingTime)
    }
    
    func testFastManager_saveAndLoad() {
                
        fastManager.startFasting()
        fastManager.stopFasting()
        fastManager.startFasting()
        fastManager.stopFasting()

        fastManager.save()

        let anotherFastManager = FastManager()
        anotherFastManager.load()

        XCTAssertEqual(fastManager.latestStartTime, anotherFastManager.latestStartTime)
        XCTAssertEqual(fastManager.latestEndTime, anotherFastManager.latestEndTime)
        XCTAssertEqual(fastManager.fasts.count, anotherFastManager.fasts.count)
    }
    
    func testFastManager_latestStartEndTimeWhileFasting() {
        
        fastManager.startFasting()
        
        XCTAssertEqual(fastManager.latestStartTime, fastManager.latestFast?.startTime)
        XCTAssertNil(fastManager.latestEndTime)
    }
    
    func testFastManager_latestStartEndTimeWhileNotFasting() {
        
        fastManager.startFasting()
        fastManager.stopFasting()
        
        XCTAssertEqual(fastManager.latestStartTime, fastManager.fasts.last?.startTime)
        XCTAssertEqual(fastManager.latestEndTime, fastManager.fasts.last?.endTime)
    }
    
    func testFastManager_testStreakWithConsecutiveSuccessfulFasts() {
        // Configure two successful fasts within the allowed time frame
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let dayBeforeYesterday = calendar.date(byAdding: .day, value: -2, to: now)!

        let firstFast = Fast(startTime: dayBeforeYesterday, endTime: yesterday)
        let secondFast = Fast(startTime: yesterday, endTime: now)

        fastManager.fasts = [secondFast, firstFast] // Assuming the first in the array is the most recent

        XCTAssertEqual(fastManager.streak, 2, "Streak should be 2 for consecutive successful fasts")
    }
    
    func testFastManager_testStreakEndsWithUnsuccessfulFast() {
        // Add one successful fast followed by an unsuccessful one
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!

        let successfulFast = Fast(startTime: yesterday, endTime: now)
        let unsuccessfulFast = Fast(startTime: now, endTime: now)

        fastManager.fasts = [unsuccessfulFast, successfulFast]

        XCTAssertEqual(fastManager.streak, 0, "Streak should end with an unsuccessful fast")
    }
    
    func testFastManager_testStreakEndsWithLargeGapBetweenFasts() {
        // Setup two successful fasts with a large gap between them
        let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: now)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now)!
        let fourDaysAgo = calendar.date(byAdding: .day, value: -4, to: now)!

        let firstFast = Fast(startTime: fourDaysAgo, endTime: threeDaysAgo)
        let secondFast = Fast(startTime: oneDayAgo, endTime: now)

        fastManager.fasts = [secondFast, firstFast]

        XCTAssertEqual(fastManager.streak, 1, "Streak should end due to a large gap between fasts")
    }
    
    func testFastManager_testStreakWithOngoingFast() {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let dayBeforeYesterday = calendar.date(byAdding: .day, value: -2, to: now)!

        let firstFast = Fast(startTime: dayBeforeYesterday, endTime: yesterday)
        let secondFast = Fast(startTime: yesterday)

        fastManager.fasts = [secondFast, firstFast] // Assuming the first in the array is the most recent

        XCTAssertEqual(fastManager.streak, 2, "Streak should be 2 for consecutive successful fasts, even if one is not completed")
    }

}
