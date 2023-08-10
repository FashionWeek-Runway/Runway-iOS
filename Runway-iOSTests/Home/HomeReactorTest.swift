//
//  HomeReactorTest.swift
//  Runway-iOSTests
//
//  Created by 김인환 on 2023/08/07.
//

import XCTest
@testable import Runway_iOS

import RxSwift

final class HomeReactorTest: XCTestCase {
    
    var reactor: HomeReactor!
    var provider: ServiceProviderType!
    var disposeBag = DisposeBag()

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
        let expectation = self.expectation(description: "viewWillAppear")
        reactor.state.subscribe(onNext: { state in
            state.nickname?.isEmpty == false ? expectation.fulfill() : ()
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5  )
        XCTAssertNotNil(reactor.currentState.nickname)
    }
}
