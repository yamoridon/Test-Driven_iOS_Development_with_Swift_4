//
//  Location.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/03.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        if lhs.coordinate?.latitude != rhs.coordinate?.latitude {
            return false
        }
        if lhs.coordinate?.longitude != rhs.coordinate?.longitude {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        return true
    }

    let name: String
    let coordinate: CLLocationCoordinate2D?

    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }

    init?(dict: [String: Any]) {
        guard let name = dict[nameKey] as? String else { return nil }

        let coordinate: CLLocationCoordinate2D?
        if let latitude = dict[latitudeKey] as? Double,
            let longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            coordinate = nil
        }

        self.name = name
        self.coordinate = coordinate
    }

    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"

    var plistDict: [String: Any] {
        var dict = [String: Any]()

        dict[nameKey] = name

        if let coordinate = coordinate {
            dict[latitudeKey] = coordinate.latitude
            dict[longitudeKey] = coordinate.longitude
        }
        return dict
    }
}
