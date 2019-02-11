//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/11.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController)

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
    }

    func test_HasTitleLabel() {
        let titleLabelIsSubView = sut.titleLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }

    func test_HasDateLabel() {
        let dateLabelIsSubView = sut.dateLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(dateLabelIsSubView)
    }

    func test_HasLocationLabel() {
        let locationLabelIsSubView = sut.locationLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(locationLabelIsSubView)
    }

    func test_HasDescriptionLabel() {
        let descriptionLabelIsSubView = sut.descriptionLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(descriptionLabelIsSubView)
    }

    func test_HasMapView() {
        let mapViewIsSubView = sut.mapView?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(mapViewIsSubView)
    }

    func test_SettingItemInfo_SetsTextsToLabels() {
        let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)
        let location = Location(name: "Foo", coordinate: coordinate)
        let item = ToDoItem(
            title: "Bar",
            itemDescription: "Baz",
            timestamp: 1456150025,
            location: location
        )

        let itemManager = ItemManager()
        itemManager.add(item)

        sut.itemInfo = (itemManager, 0)

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, "Foo")
        XCTAssertEqual(sut.descriptionLabel.text, "Baz")
        XCTAssertEqual(
            sut.mapView.centerCoordinate.latitude,
            coordinate.latitude,
            accuracy: 0.001
        )
        XCTAssertEqual(
            sut.mapView.centerCoordinate.longitude,
            coordinate.longitude,
            accuracy: 0.001
        )
    }

    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))

        sut.itemInfo = (itemManager, 0)
        sut.checkItem()

        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}
