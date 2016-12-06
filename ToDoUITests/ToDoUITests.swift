//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Nicholas Sakaimbo on 12/4/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest

// TODO: Add test to check item
// TODO: Add test to uncheck item
// TODO: Add test to show item detail

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
   
    func testAddToDoItem_DisplaysAddedItemInItemList() {
        
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("meeting")
        
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2017")
        
        let locationNameTextField = app.textFields["Location Name"]
        locationNameTextField.tap()
        locationNameTextField.tap()
        locationNameTextField.typeText("office")
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.tap()
        addressTextField.typeText("1 infinite loop")
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.tap()
        descriptionTextField.typeText("do stuff")
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2017"].exists)
        XCTAssertTrue(app.tables.staticTexts["office"].exists)
    }
    
    override func tearDown() {
        super.tearDown()
    }
   
}
