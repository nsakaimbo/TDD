//
//  ItemCellTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 10/30/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable
import ToDo

extension ItemCellTests {
    
    class FakeDataSource: NSObject, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}

class ItemCellTests: XCTestCase {
    
    var sut: ItemCell!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: ItemListViewController.self)) as! ItemListViewController
        
        _ = controller.view
        
        let tableView = controller.tableView
        let provider = FakeDataSource()
        tableView?.dataSource = provider
        tableView?.reloadData()
        
        sut = tableView?.dequeueReusableCell(withIdentifier: String(describing: ItemCell.self), for: IndexPath(row: 0, section: 0)) as! ItemCell
    }
    
    func testCell_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func testCell_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }
    
    func testCell_HasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
    }
    
    func testConfigWithItem_SetsLabel() {
        
        let title = "first"
        let description = "test description"
        let timestamp: Double = 1456150025
        let location = Location(name: "Home")
        
        sut.config(with: ToDoItem(title: title, itemDescription: description, timestamp: timestamp, location: location))
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.locationLabel.text, "Home")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
    }
    
    func testTitle_ForCheckedTasks_IsStruckThrough() {
        
        let title = "first"
        let description = "test description"
        let timestamp: Double = 1456150025
        let location = Location(name: "Home")
        
        let item = ToDoItem(title: title, itemDescription: description, timestamp: timestamp, location: location)
        
        sut.config(with: item, isChecked: true)
        
        let attributedString = NSAttributedString(string: title, attributes: [
            NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ])
        
        XCTAssertEqual(sut.titleLabel.attributedText, attributedString)
        XCTAssertNil(sut.locationLabel.text)
        XCTAssertNil(sut.dateLabel.text)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
