//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/10/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable
import ToDo
import CoreLocation

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: InputViewController.self)) as! InputViewController
        
        _ = sut.view
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAddressTestField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }
    
    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "test title"
        sut.dateTextField.text = "02/22/2016"
        sut.locationTextField.text = "test location"
        sut.addressTextField.text = "infinite loop"
        sut.descriptionTextField.text = "test description"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "test title", itemDescription: "test description", timestamp: 1456117200, location: Location(name: "test location", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func testSave_CreatesToDoItemWithTitleDateAndDescription() {
        sut.titleTextField.text = "test title"
        sut.descriptionTextField.text = "test description"
        sut.dateTextField.text = "02/22/2016"
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "test title",
                                itemDescription: "test description",
                                timestamp: 1456117200)
        
        XCTAssertEqual(item, testItem)
    }
    
    func testSave_SuccessWithTitleOnly() {
        sut.titleTextField.text = "test title"
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "test title")
        
        XCTAssertEqual(item, testItem)
    }
    
    func testSaveButton_HasSaveAction() {
        let saveButton = sut.saveButton
        
        guard let action = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside)?.first else {
            XCTFail()
            return
        }
     
        XCTAssertEqual(action, "save")
    }
    
    func test_GeocoderWorksAsExpected() {
        
        let expectationForGeocoder = expectation(description: "Wait for geocode")
        
        CLGeocoder().geocodeAddressString("infinite loop 1") { (placemarks, error) in
            
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            
            guard let latitude = coordinate?.latitude,
                let longitude = coordinate?.longitude else {
                    XCTFail("Error. Could not fetch valid latitude and longitude from coordinate.")
                    return
            }
            
            XCTAssertEqualWithAccuracy(latitude, 37.3316851, accuracy: 0.0001)
            
            
            XCTAssertEqualWithAccuracy(longitude, -122.0300674, accuracy: 0.0001)
           
            
            expectationForGeocoder.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

extension InputViewControllerTests {
    
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
