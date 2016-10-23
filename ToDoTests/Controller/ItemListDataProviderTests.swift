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
        sut.itemManager = ItemManager()
        
        tableView.dataSource = sut
    }
   
    func testNumberOfSectionsIsTwo() {
        XCTAssertEqual(tableView.numberOfSections, 2)
    }
    
    func testNumberOfRowsInFirstSection_IsToDoCount() {
        
        sut.itemManager?.addItem(ToDoItem(title: "first"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.itemManager?.addItem(ToDoItem(title: "second"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.addItem(ToDoItem(title: "first"))
        sut.itemManager?.addItem(ToDoItem(title: "second"))
        
        sut.itemManager?.checkItemAtIndex(0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRow_ReturnsItemCell() {
        sut.itemManager?.addItem(ToDoItem(title: "first"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ItemCell)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        tableView = nil
    }
    
}
