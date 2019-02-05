//
//  ItemListDataProviderTests.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/06.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {
    var sut: ItemListDataProvider!
    var tableView: UITableView!

    override func setUp() {
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()

        tableView = UITableView()
        tableView.dataSource = sut
    }

    override func tearDown() {
    }

    func test_NumberOfSections_IsTwo() {
        let numberOfSections = tableView.numberOfSections

        XCTAssertEqual(numberOfSections, 2)
    }

    func test_NumberOfRows_Section1_IsToDoCount() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)

        sut.itemManager?.add(ToDoItem(title: "Bar"))
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func test_NumberOfRows_Section2_IsToDoneCount() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        sut.itemManager?.add(ToDoItem(title: "Bar"))
        sut.itemManager?.checkItem(at: 0)

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)

        sut.itemManager?.checkItem(at: 0)
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }

    func test_CellForRow_ReturnsItemCell() {
        sut.itemManager?.add(ToDoItem(title: "Foo"))
        tableView.reloadData()

        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is ItemCell)
    }
}
