//
//  ItemListViewControllerTest.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/04.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTest: XCTestCase {
    var sut: ItemListViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = (viewController as! ItemListViewController)

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
    }

    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }

    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }

    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func test_LoadingView_DataSourceEqualDelegate() {
        XCTAssertEqual(
            sut.tableView.dataSource as? ItemListDataProvider,
            sut.tableView.delegate as? ItemListDataProvider
        )
    }

    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }


    func test_AddItem_PresetnsAddItemViewController() {
        guard let inputViewController = performAddButtonAction() else {
            XCTFail()
            return
        }

        XCTAssertNotNil(inputViewController.titleTextField)
    }

    func testItemListVC_SharesItemManagerWithInputVC() {
        guard let inputViewController = performAddButtonAction() else {
            XCTFail()
            return
        }

        guard let inputItemManager = inputViewController.itemManager else {
            XCTFail()
            return
        }

        XCTAssertTrue(sut.itemManager === inputItemManager)
    }

    func performAddButtonAction() -> InputViewController? {
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            return nil
        }
        guard let action = addButton.action else {
            return nil
        }

        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)

        let inputViewController = sut.presentedViewController as? InputViewController

        return inputViewController
    }

    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func test_ViewWillApper_ReloadTableView() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockTableView.reloadDataGotCalled)
    }
}

extension ItemListViewControllerTest {
    class MockTableView: UITableView {
        var reloadDataGotCalled = false

        override func reloadData() {
            reloadDataGotCalled = true
        }
    }
}
