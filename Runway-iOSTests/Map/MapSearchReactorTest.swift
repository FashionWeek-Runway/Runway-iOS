//
//  MapSearchReactorTest.swift
//  Runway-iOSTests
//
//  Created by 김인환 on 2023/07/03.
//

import XCTest
@testable import Runway_iOS

final class MapSearchReactorTest: XCTestCase {
    
    var reactor: MapSearchReactor!
    var provider: ServiceProviderType!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        provider = DataRepository.shared
        reactor = MapSearchReactor(provider: self.provider, mapLocation: (0, 0))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveSearchHistory() throws {
        // Given
        
        
        // When
        
        
        // Then
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
