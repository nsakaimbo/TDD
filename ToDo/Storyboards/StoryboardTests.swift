//
//  StoryboardTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/26/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable
import ToDo

class StoryboardTests: XCTestCase {
    
    var sut: ItemListViewController!
    var addButton: UIBarButtonItem!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        guard let rootViewController = navigationController.viewControllers.first as? ItemListViewController else {
            assertionFailure("Error. Initial view controller is not ItemListViewController.")
            return
        }
        
        sut = rootViewController
        
        guard let button = sut.navigationItem.rightBarButtonItem else {
            assertionFailure("Error. Could not establish reference to add UIBarButtonItem.")
            return
        }
        
        addButton = button
        
        // NOTE: - Contrary to the example (which was written in Swift 2.2), we need to assign the navigation controller, and NOT the view controller, to the shared keyWindow property
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        
        assert(sut.presentedViewController == nil)
        
         sut.perform(#selector(ItemListViewController.addButtonPressed(_:)), with: addButton)
    }
    
    func testNavigationController_RightBarButtonItem_IsAddWithSelfAsTarget() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController, sut)
    }
    
    func testAddItem_PresentsAddItemViewController() {
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        
        let inputViewController = sut.presentedViewController as! InputViewController
        
        guard let inputItemManager = inputViewController.itemManager else {
            XCTFail(); return;
        }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
