////
//  MainCoordinatorTests.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import XCTest
@testable import Mooch

class MainCoordinatorTests: XCTestCase {

    var nav: UINavigationController!
    var coordinator: MainCoordinator!
    
    override func setUp() {
        nav = UINavigationController()
        coordinator = MainCoordinator(nav: nav)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainCoordinatorStarts() {
        coordinator.start()
        XCTAssertTrue(nav.topViewController is LandingViewController)
        XCTAssertTrue((nav.topViewController as! LandingViewController).viewModel is LandingViewModel)
    }
    
    func testOnboardingBegins() {
        coordinator.onboarding()
        XCTAssertTrue(nav.topViewController is OnboardingViewController)
    }
    
    func testLogin() {
        coordinator.signup()
        XCTAssertTrue(nav.topViewController is LoginViewController)
    }
    
    

}
