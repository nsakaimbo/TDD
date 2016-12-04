//
//  ToDoItem.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 8/29/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    private enum PlistKeys: String {
        case title
        case itemDescription
        case timeStamp
        case location
    }
    
    var plistDict: NSDictionary {
        
        var dict = [String:AnyObject]()
        
        dict[PlistKeys.title.rawValue] = title as NSString
        dict[PlistKeys.itemDescription.rawValue] = itemDescription as NSString?
        dict[PlistKeys.timeStamp.rawValue] = timestamp as NSNumber?
        dict[PlistKeys.location.rawValue] = location?.plistDict
        
        return dict as NSDictionary
    }
    
    init?(dict: NSDictionary) {
        guard let title = dict[PlistKeys.title.rawValue] as? String else {
            return nil
        }
        
        self.title = title
        self.itemDescription = dict[PlistKeys.itemDescription.rawValue] as? String
        self.timestamp = dict[PlistKeys.timeStamp.rawValue] as? Double
        
        if let locationDict = dict[PlistKeys.location.rawValue] as? NSDictionary {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }
}

func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    
    if lhs.title != rhs.title { return false }
    if lhs.location != rhs.location{ return false }
    if lhs.timestamp != rhs.timestamp { return false }
    if lhs.itemDescription != rhs.itemDescription { return false }
    
    return true
}
