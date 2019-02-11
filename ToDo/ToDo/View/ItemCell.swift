//
//  ItemCell.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/06.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    lazy var dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    func configCell(with item: ToDoItem, checked: Bool = false) {
        if checked {
            let attributeString = NSAttributedString(
                string: item.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            titleLabel.attributedText = attributeString
            locationLabel.text = nil
            dateLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name ?? ""

            if let timestamp = item.timestamp {
                let date = Date(timeIntervalSince1970: timestamp)
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
}
