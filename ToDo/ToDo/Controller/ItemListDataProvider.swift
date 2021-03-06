//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/04.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import UIKit

enum Section: Int {
    case toDo
    case done
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerSettable {
    var itemManager: ItemManager?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else { return 0 }
        guard let itemSection = Section(rawValue: section) else { fatalError() }

        let numberOfRows: Int
        switch itemSection {
        case .toDo:
            numberOfRows = itemManager.toDoCount
        case .done:
            numberOfRows = itemManager.doneCount
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
            fatalError()
        }

        guard let itemManger = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        let item: ToDoItem
        switch section {
        case .toDo:
            item = itemManger.item(at: indexPath.row)
        case .done:
            item = itemManger.doneItem(at: indexPath.row)
        }

        cell.configCell(with: item)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        let buttonTitle: String
        switch section {
        case .toDo:
            buttonTitle = "Check"
        case .done:
            buttonTitle = "Uncheck"
        }

        return buttonTitle
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        switch section {
        case .toDo:
            itemManager.checkItem(at: indexPath.row)
        case .done:
            itemManager.uncheckItem(at: indexPath.row)
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemSelection = Section(rawValue: indexPath.section) else { fatalError() }

        switch itemSelection {
        case .toDo:
            NotificationCenter.default.post(
                name: Notification.Name("ItemSelectedNotification"),
                object: self,
                userInfo: ["index": indexPath.row]
            )
        default:
            break
        }
    }
}

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}
