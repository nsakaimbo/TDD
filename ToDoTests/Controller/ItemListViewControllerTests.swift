//
//  ItemListViewControllerTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 9/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

extension ItemListViewControllerTests {
    
    class MockItemListViewController: ItemListViewController {
        
        let mockTableView = MockTableView()
        let mockDataProvider = ItemListDataProvider()
        
        override var tableView: UITableView! {
            get {
                return mockTableView
            }
            set {
                
            }
        }
        
        override var tableViewDelegateDataSource: (ItemManagerSettable & UITableViewDataSource & UITableViewDelegate)! {
            get {
                return mockDataProvider
            }
            set {
                
            }
        }
    }
    
    class MockTableView: UITableView {
        
        var reloadDataWasCalled: Bool = false
        
        override func reloadData() {
            reloadDataWasCalled = true
        }
    }
    
    class MockNavigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}

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
                XCTFail("Either the delegate and/or data source is not instantiated.")
                return
        }
        
        XCTAssertTrue(dataSource === delegate)
    }
   
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.tableViewDelegateDataSource.itemManager)
    }
    
    func testViewWillAppear_ReloadsTableView() {
        
        // This is how you test IBOutlets!
        let mockItemListViewController = MockItemListViewController()
        
        mockItemListViewController.beginAppearanceTransition(true, animated: true)
        mockItemListViewController.endAppearanceTransition()
        XCTAssertTrue((mockItemListViewController.tableView as! MockTableView).reloadDataWasCalled)
    }
    
    func testItemSelectedNotification_PushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        // Trigger viewDidLoad() because we assume this is where sut is added as an observer to NotificationCenter.default
        _ = sut.view
      
        // Post the notification expected by sut
        let notification = Notification(name: Notification.Name(rawValue: "ItemSelectedNotification"), object: self, userInfo: ["index": 1])
        
        NotificationCenter.default.post(notification)
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail(); return
        }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else {
            XCTFail(); return
        }
        
        guard let index = detailViewController.itemInfo?.1 else {
            XCTFail(); return
        }

        _ = detailViewController.view
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}


