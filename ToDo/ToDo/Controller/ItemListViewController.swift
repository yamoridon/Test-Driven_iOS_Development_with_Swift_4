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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?
            .instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
