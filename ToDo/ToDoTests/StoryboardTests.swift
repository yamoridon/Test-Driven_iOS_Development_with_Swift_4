//
//  StoryboardTests.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/12.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
@testable import ToDo

class StoryboardTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func test_InitialViewController_IsItemListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let rootViewController = navigationController?.viewControllers[0]

        XCTAssertTrue(rootViewController is ItemListViewController)
    }
}
