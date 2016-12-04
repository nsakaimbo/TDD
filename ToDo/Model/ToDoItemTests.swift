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
   
    // MARK: Equality
    
    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "first")
        let secondItem = ToDoItem(title: "first")
        
        XCTAssertEqual(firstItem, secondItem)
    }
   
    func testWhenLocationDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "first title", itemDescription: "first description", timestamp: 0.0, location: Location(name: "home"))
        let secondItem = ToDoItem(title: "first title", itemDescription: "first description", timestamp: 0.0, location: Location(name: "office"))
        
        XCTAssertNotEqual(firstItem, secondItem, "Location should not be equal")
    }
    
    func testWhenOneLocationIsNilAndOtherIsnt_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "title", itemDescription: "description", timestamp: 0.0, location: nil)
        let secondItem = ToDoItem(title: "title", itemDescription: "description", timestamp: 0.0, location: Location(name: "home"))
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
   
    func testWhenTimestampDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "title", itemDescription: "description", timestamp: 0.1, location: nil)
        let secondItem = ToDoItem(title: "title", itemDescription: "description", timestamp: 0.0, location: nil)
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
  
    func testWhenDescriptionDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "title", itemDescription: "first description", timestamp: 0.0, location: nil)
        let secondItem = ToDoItem(title: "title", itemDescription: "second description", timestamp: 0.0, location: nil)
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testWhenTitleDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "first title", itemDescription: "description", timestamp: 0.0, location: nil)
        let secondItem = ToDoItem(title: "second title", itemDescription: "description", timestamp: 0.0, location: nil)
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    // MARK: Initialization
    
    func testInit_ShouldSetTitle() {
        let item = ToDoItem(title: "test title")
        
        XCTAssertEqual(item.title, "test title", "Initializer should set the item title")
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
    
    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "first")
        let dictionary = item.plistDict
        
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }
    
    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "home")
        let item = ToDoItem(title: "home", itemDescription: "test description", timestamp: 1.0, location: location)
        
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        
        XCTAssertEqual(item, recreatedItem)
    }
}
