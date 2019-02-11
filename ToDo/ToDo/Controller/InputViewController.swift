//
//  InputViewController.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/11.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?

    let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    @IBAction func save() {
        guard let titleString = titleTextField.text, !titleString.isEmpty else { return }
        let date: Date?
        if let dateText = self.dateTextField.text, !dateText.isEmpty {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        let descriptionString = descriptionTextField.text
        guard let locationName = locationTextField.text, !locationName.isEmpty else { return }
        guard let address = addressTextField.text, !address.isEmpty else { return }
        geocoder.geocodeAddressString(address) { [unowned self] placeMarks, error in
            let placeMark = placeMarks?.first
            let item = ToDoItem(
                title: titleString,
                itemDescription: descriptionString,
                timestamp: date?.timeIntervalSince1970,
                location: Location(
                    name: locationName,
                    coordinate: placeMark?.location?.coordinate
                )
            )
            self.itemManager?.add(item)
        }
    }
}
