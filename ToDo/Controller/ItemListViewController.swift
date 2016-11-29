//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }
    @IBOutlet var tableViewDelegateDataSource: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        tableView.dataSource = tableViewDelegateDataSource
        tableView.delegate = tableViewDelegateDataSource
        tableViewDelegateDataSource.itemManager = itemManager
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: String(describing: InputViewController.self)) as? InputViewController {
            
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
