//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewDelegateDataSource: protocol<UITableViewDataSource, UITableViewDelegate>!
    
    override func viewDidLoad() {
        tableView.dataSource = tableViewDelegateDataSource
        tableView.delegate = tableViewDelegateDataSource
    }
}
