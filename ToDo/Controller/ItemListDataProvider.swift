//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/25/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import UIKit

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
