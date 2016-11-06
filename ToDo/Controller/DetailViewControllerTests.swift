//
//  DetailViewControllerTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/6/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable
import ToDo
import CoreLocation

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        
        _ = sut.view
    }
    
    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_HasDateLabel() {
        XCTAssertNotNil(sut.dueDateLabel)
    }
    
    func test_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }
    
    func test_HasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
    }
    
    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }
    
    func testSettingItemInfo_SetsTextsToLabels() {
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        let title = "test title"
        let description = "test description"
        let timestamp: Double = 1456150025
        let location = Location(name: "test location", coordinate: coordinate)
        
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: title,
                                     itemDescription: description,
                                     timestamp: timestamp,
                                     location: location))
        
        sut.itemInfo = (itemManager, 0)
        
        // Trigger the call of viewWillAppear(_:) and viewDidAppear(_:) and similar methods for the presentation of the view hierarchy
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.dueDateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, "test location")
        XCTAssertEqual(sut.descriptionLabel.text, description)
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude , accuracy: 0.001)
    }
    
    func testCheckItem_ChecksItemInItemManager() {
        
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "test title"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
