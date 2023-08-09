//
//  HomeReactorTest.swift
//  Runway-iOSTests
//
//  Created by 김인환 on 2023/08/07.
//

import XCTest

@testable import Runway_iOS

final class HomeReactorTest: XCTestCase {
    
    var reactor: HomeReactor!
    var provider: ServiceProviderType!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        provider = DataRepository.shared
        reactor = HomeReactor(provider: self.provider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewWillAppear() {
        // when
        reactor.action.onNext(.viewWillAppear)
        
        // then
        XCTAssertEqual(reactor.currentState.pagerData.count, 2)
        XCTAssertEqual(reactor.currentState.userReview.count, 2)
        XCTAssertEqual(reactor.currentState.userReviewIsLast, false)
        XCTAssertEqual(reactor.currentState.userReviewPage, 0)
    }
}
