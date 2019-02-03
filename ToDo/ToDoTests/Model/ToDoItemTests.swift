//
//  ToDoItemTests.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/03.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func test_Init_WhenGivenTitle_SetsTitle() {
        let item = ToDoItem(title: "Foo")

        XCTAssertEqual(item.title, "Foo", "should set title")
    }

    func test_Init_WhenGivenDescription_SetsDescription() {
        let item = ToDoItem(title: "Foo", itemDescription: "Bar")

        XCTAssertEqual(item.itemDescription, "Bar", "should set itemDescription")
    }

    func test_InitSetsTimestamp() {
        let item = ToDoItem(title: "", timestamp: 0.0)

        XCTAssertEqual(item.timestamp, 0.0, "should set timestamp")
    }

    func test_Init_WhenGivenLocaltion_SetsLocation() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "", location: location)

        XCTAssertEqual(item.location?.name, location.name, "should set location")
    }

    func test_EqualItems_AreEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Foo")

        XCTAssertEqual(first, second)
    }

    func test_Items_WhenLocationDiffers_AreNotEqual() {
        let first = ToDoItem(title: "", location: Location(name: "Foo"))
        let second = ToDoItem(title: "", location: Location(name: "Bar"))

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenOneLocationIsNil_AreNotEqual() {
        var first = ToDoItem(title: "", location: Location(name: "Foo"))
        var second = ToDoItem(title: "", location: nil)

        XCTAssertNotEqual(first, second)

        first = ToDoItem(title: "", location: nil)
        second = ToDoItem(title: "", location: Location(name: "Foo"))

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTimestampsDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", timestamp: 1.0)
        let second = ToDoItem(title: "Foo", timestamp: 0.0)

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenDescriptionsDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", itemDescription: "Bar")
        let second = ToDoItem(title: "Foo", itemDescription: "Baz")

        XCTAssertNotEqual(first, second)
    }

    func test_Items_WhenTitlesDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Bar")

        XCTAssertNotEqual(first, second)
    }
}
