//
//  FirstDemoTests.swift
//  FirstDemoTests
//
//  Created by Kazuki Ohara on 2019/01/27.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
@testable import FirstDemo

class FirstDemoTests: XCTestCase {

    var viewController: ViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = ViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NumberOfVowels_WhenPassedDominik_ReturnsThree() {
        let string = "Dominik"

        let numberOfVowels = viewController.numberOfVowels(in: string)

        XCTAssertEqual(numberOfVowels, 3, "shoud find 3 vowels in Dominik")
    }

    func test_MakeHeadline_RetunrsStringWithEachWordStartCapital() {
        let input          = "this is A test headline"
        let expectedOutput = "This Is A Test Headline"

        let headline = viewController.makeHeadline(from: input)

        XCTAssertEqual(headline, expectedOutput)
    }

    func test_MakeHeadline_ReturnsStringWithEachWordStartCapital2() {
        let input          = "Here is another Example"
        let expectedOutput = "Here Is Another Example"

        let headline = viewController.makeHeadline(from: input)

        XCTAssertEqual(headline, expectedOutput)
    }
}
