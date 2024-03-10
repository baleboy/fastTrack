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
    
    override func setUp() {
        super.setUp()
        testUserDefaults = UserDefaults(suiteName: testDomain)
        fastManager = FastManager(userDefaults: testUserDefaults)
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

}
