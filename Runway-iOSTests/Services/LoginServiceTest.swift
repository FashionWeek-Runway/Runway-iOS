//
//  LoginServiceTest.swift
//  Runway-iOSTests
//
//  Created by 김인환 on 2023/08/11.
//

import XCTest
@testable import Runway_iOS

import RxSwift

final class LoginServiceTest: XCTestCase {
    
    let service = LoginService(baseURL: APIServiceURL.RUNWAY_BASEURL)
    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }

    func testLogin() {
        let expectation = self.expectation(description: "testLogin")
        
        service.login(password: "1234asdf", phone: "01012121212")
            .subscribe(onNext: { request in
                request.responseData { response in
                    if response.response?.statusCode == 200 {
                        expectation.fulfill()
                    }
                }
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5)
    }
}
