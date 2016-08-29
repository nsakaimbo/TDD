//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by Nicholas Sakaimbo on 8/29/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    func testInit_ShouldSetTitle() {
        let item = ToDoItem(title: "Test title")
        
        XCTAssertEqual(item.title, "Test title", "Initializer should set the item title")
    }
    
    func testInit_ShouldSetTitleAndDescription() {
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description")
        
        XCTAssertEqual(item.itemDescription, "Test description", "Initalizer should set the item description")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestamp() {
        let item = ToDoItem(title: "test title",
                            itemDescription: "test description",
                            timestamp: 0.0)
        
        XCTAssertEqual(item.timestamp, 0.0, "Initializer should set the timestamp")
    }
    
    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "test name")
        let item = ToDoItem(title: "test title",
                            itemDescription: "test description",
                            timestamp: 0.0,
                            location: location)
        
        XCTAssertEqual(location.name, item.location?.name, "Initializer should set the location")
    }
    
}