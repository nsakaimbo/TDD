//
//  ItemManager.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/2/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import Foundation

class ItemManager {
   
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
   
    fileprivate var toDoItems = [ToDoItem]()
    fileprivate var doneItems = [ToDoItem]()
    
    func addItem(_ item: ToDoItem) {
        guard !toDoItems.contains(item) else { return }
        toDoItems.append(item)
    }
    
    func itemAtIndex(_ index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func checkItemAtIndex(_ index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func doneItemAtIndex(_ index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
}
