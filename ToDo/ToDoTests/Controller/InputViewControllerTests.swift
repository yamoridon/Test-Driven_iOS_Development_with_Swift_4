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
        sut = (storybard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController)

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let date = dateFormatter.date(from: "08/27/2017")!
        let timestamp = date.timeIntervalSince1970

        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Baz"

        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder

        sut.itemManager = ItemManager()

        sut.save()

        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(
            37.3316851,
            -122.0300674
        )
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)

        let item = sut.itemManager?.item(at: 0)

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
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
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

        waitForExpectations(timeout: 10, handler: nil)
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
}
