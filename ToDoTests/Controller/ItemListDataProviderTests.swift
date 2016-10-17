//
//  ItemListDataProviderTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/25/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {
    
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        tableView = UITableView()
        sut = ItemListDataProvider()
        
        tableView.dataSource = sut
    }
   
    func testNumberOfSectionsIsTwo() {
       
        XCTAssertEqual(tableView.numberOfSections, 2)
    }
    
    func testNumberOfRowsInFirstSection_IsToDoCount() {
        sut.itemManager?.addItem(ToDoItem(title: "first item"))
    }
    
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        tableView = nil
    }
    
}
