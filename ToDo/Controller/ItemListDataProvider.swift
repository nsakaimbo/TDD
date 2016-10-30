//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/25/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import UIKit

enum Section: Int {
    case ToDo
    case Done
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {

    var itemManager: ItemManager?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let itemManager = itemManager,
            let itemSection = Section(rawValue: section) else {
                return 0
        }
        
        let numberOfRows: Int
    
        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount
        case .Done:
            numberOfRows = itemManager.doneCount
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ItemCell.self), for: indexPath) as! ItemCell
        
        guard let itemManager = self.itemManager else {
            fatalError("Error. Could not establish reference to itemManager object.")
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Error. Could not instantiate valid section reference")
        }
        
        let item: ToDoItem
        
        switch section {
        case .ToDo:
            item = itemManager.itemAtIndex(indexPath.row)
        case .Done:
            item = itemManager.doneItemAtIndex(indexPath.row)
        }
        
        cell.configCellWithItem(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Could not establish valid section for section title.")
        }
        
        let buttonTitle: String
        switch section {
        case .ToDo:
            buttonTitle = "Check"
        case .Done:
            buttonTitle = "Uncheck"
        }
        
        return buttonTitle
    }
}
