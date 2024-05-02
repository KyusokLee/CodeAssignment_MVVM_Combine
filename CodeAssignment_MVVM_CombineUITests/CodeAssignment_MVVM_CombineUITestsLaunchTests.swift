//
//  CodeAssignment_MVVM_CombineUITestsLaunchTests.swift
//  CodeAssignment_MVVM_CombineUITests
//
//  Created by gyusoku.i on 2024/05/02.
//

import XCTest

final class CodeAssignment_MVVM_CombineUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
