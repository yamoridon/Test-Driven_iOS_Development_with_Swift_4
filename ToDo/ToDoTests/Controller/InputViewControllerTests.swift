//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Kazuki Ohara on 2019/02/11.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class InputViewControllerTests: XCTestCase {
    var sut: InputViewController!
    var placemark: MockPlacemark!

    override func setUp() {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        sut = storybard.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController
        XCTAssertNotNil(sut)

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
    }

    func test_HasTitleTextField() {
        let titleTextFieldIsSubView = sut.titleTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleTextFieldIsSubView)
    }

    func test_HasDateTextField() {
        let dateTextFieldIsSubView = sut.dateTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(dateTextFieldIsSubView)
    }

    func test_HasLocationTextField() {
        let locationTextFieldIsSubView = sut.locationTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(locationTextFieldIsSubView)
    }

    func test_HasAddressTextField() {
        let addressTextFieldIsSubView = sut.addressTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(addressTextFieldIsSubView)
    }

    func test_HasDescriptionTextField() {
        let descriptionTextFieldIsSubView = sut.descriptionTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(descriptionTextFieldIsSubView)
    }

    func test_HasSaveButton() {
        let saveButtonIsSubView = sut.saveButton?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(saveButtonIsSubView)
    }

    func test_HasCancelButton() {
        let cancelButtonIsSubView = sut.cancelButton?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(cancelButtonIsSubView)
    }

    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let mockSut = MockInputViewController()

        mockSut.titleTextField = UITextField()
        mockSut.dateTextField = UITextField()
        mockSut.locationTextField = UITextField()
        mockSut.addressTextField = UITextField()
        mockSut.descriptionTextField = UITextField()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let date = dateFormatter.date(from: "08/27/2017")!
        let timestamp = date.timeIntervalSince1970

        mockSut.titleTextField.text = "Foo"
        mockSut.dateTextField.text = dateFormatter.string(from: date)
        mockSut.locationTextField.text = "Bar"
        mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockSut.descriptionTextField.text = "Baz"

        let mockGeocoder = MockGeocoder()
        mockSut.geocoder = mockGeocoder

        mockSut.itemManager = ItemManager()

        let dismissExpectation = expectation(description: "Dismiss")

        mockSut.completionHandler = {
            dismissExpectation.fulfill()
        }

        mockSut.save()

        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(
            37.3316851,
            -122.0300674
        )
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)

        waitForExpectations(timeout: 1, handler: nil)

        let item = mockSut.itemManager?.item(at: 0)

        let testItem = ToDoItem(
            title: "Foo",
            itemDescription: "Baz",
            timestamp: timestamp,
            location: Location(
                name: "Bar",
                coordinate: coordinate
            )
        )

        XCTAssertEqual(item, testItem)
        mockSut.itemManager?.removeAll()
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton

        guard let actions = saveButton.actions(
            forTarget: sut,
            forControlEvent: .touchUpInside
        ) else {
            XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("save"))
    }

    func test_Geocoder_FetchesCoordinates() {
        let geocoderAnswered = expectation(description: "Geocoder")

        let address = "Infinite Loop 1, Cupertino"
        CLGeocoder().geocodeAddressString(address) { placemarks, _ in
            let coordinate = placemarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }

            XCTAssertEqual(latitude, 37.3316, accuracy: 0.001)
            XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)

            geocoderAnswered.fulfill()
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func test_Save_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"

        mockInputViewController.save()

        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
}

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(
            _ addressString: String,
            completionHandler: @escaping CLGeocodeCompletionHandler
        ) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordiante = mockCoordinate else { return CLLocation() }

            return CLLocation(
                latitude: coordiante.latitude,
                longitude: coordiante.longitude
            )
        }
    }

    class MockInputViewController: InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?

        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
}
