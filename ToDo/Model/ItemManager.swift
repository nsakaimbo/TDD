//
//  ItemManager.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/2/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import Foundation

fileprivate extension Selector {
    static let save = #selector(ItemManager.save)
}

class ItemManager: NSObject {
   
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
   
    fileprivate var toDoItems = [ToDoItem]()
    fileprivate var doneItems = [ToDoItem]()
   
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: .save, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        guard let nsToDoItems = NSArray(contentsOf: toDoPathURL) as? [NSDictionary] else {
           return
        }
        
        nsToDoItems.forEach {
            if let toDoItem = ToDoItem(dict: $0) {
                toDoItems.append(toDoItem)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
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
    
    func uncheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }
    
    func doneItemAtIndex(_ index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
   
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentURL = fileURLs.first else {
            fatalError("Something went wrong. Documents url could not be found")
        }
        
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    func save() {
       
        let nsToDoItems = toDoItems.map {
            return $0.plistDict
        }
        
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).write(to: toDoPathURL, atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: toDoPathURL)
            }
            catch {
                print(error)
            }
        }
    }
}
