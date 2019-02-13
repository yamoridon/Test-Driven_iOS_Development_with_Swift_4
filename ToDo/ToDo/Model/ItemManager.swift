//
//  ItemManager.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/03.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems: [ToDoItem] = []
    private var doneItems: [ToDoItem] = []

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(save),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )

        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let dict = dict as? [String: Any] {
                    if let toDoItem = ToDoItem(dict: dict) {
                        toDoItems.append(toDoItem)
                    }
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }

    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )

        guard let documentURL = fileURLs.first else {
            fatalError("Something went wrong. Documents url clould not be found.")
        }

        return documentURL.appendingPathComponent("toDoItems.plist")
    }

    @objc func save() {
        let nsToDoItems = toDoItems.map { $0.plistDict }

        guard nsToDoItems.count > 0 else {
            try? FileManager.default.removeItem(at: toDoPathURL)
            return
        }

        do {
            let plistData = try PropertyListSerialization.data(
                fromPropertyList: nsToDoItems,
                format: .xml,
                options: 0
            )
            try plistData.write(to: toDoPathURL, options: .atomic)
        } catch {
            print(error)
        }
    }

    func add(_ item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }

    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }

    func checkItem(at index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }

    func uncheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }

    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
