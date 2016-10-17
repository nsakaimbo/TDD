//
//  ItemListViewControllerTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {

    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: ItemListViewController.self)) as! ItemListViewController
        
        // trigger the call of viewDidLoad(_:)
        _ = sut.view
    }
    
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_TableViewDataSourceDelegateNotNil() {
        
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.delegate)
        
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        
        guard let dataSource = sut.tableView.dataSource,
            let delegate = sut.tableView.delegate else {
                XCTFail("Either the delegate and/or data source are not instantiated.")
                return
        }
        
        XCTAssertTrue(dataSource === delegate)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
