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
        reactor = nil
        provider = nil
    }

    func testSetEmptyMapKeywordSearchData() throws {
        // Given
        let searchText = ""
        
        // When
        reactor.action.onNext(.searchFieldInput(searchText))
        print(reactor.currentState.mapKeywordSearchData)
        
        // Then
        XCTAssertEqual(reactor.currentState.mapKeywordSearchData.count, 0)
    }
}
