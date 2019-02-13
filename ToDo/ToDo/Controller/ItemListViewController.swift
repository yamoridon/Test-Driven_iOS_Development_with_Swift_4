//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Kazuki Ohara on 2019/02/04.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!

    let itemManager = ItemManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider

        dataProvider.itemManager = itemManager

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDetails(sender:)),
            name: Notification.Name("ItemSelectedNotification"),
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController")
        if let nextViewController = viewController as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }

    @objc func showDetails(sender: Notification) {
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }

        let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
        if let nextViewController = viewController as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
