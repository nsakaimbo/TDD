//
//  LocationTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 8/29/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable import ToDo

import CoreLocation

class LocationTests: XCTestCase {

    // MARK: Equality
    
    // Helper method for Equality testing
    private func performNotEqualTestWithLocationProperties(firstName firstName: String,
                                                                     secondName: String,
                                                                     firstLongLat: (Double, Double)?,
                                                                     secondLongLat: (Double, Double)?) {
        let line: UInt = UInt(Int(#line) - 4)
      
        let firstCoordinate: CLLocationCoordinate2D?
        if let firstLongLat = firstLongLat {
            firstCoordinate = CLLocationCoordinate2D(latitude: firstLongLat.0,
                                                     longitude: firstLongLat.1)
        } else { firstCoordinate = nil }
        
        let secondCoordinate: CLLocationCoordinate2D?
        if let secondLongLat = secondLongLat {
            secondCoordinate = CLLocationCoordinate2D(latitude: secondLongLat.0,
                                                     longitude: secondLongLat.1)
        } else { secondCoordinate = nil }
        
        let firstLocation = Location(name: firstName, coordinate: firstCoordinate)
        let secondLocation = Location(name: secondName, coordinate: secondCoordinate)
        
        XCTAssertNotEqual(firstLocation, secondLocation, line: line)
    }
    
    func testEqualLocations_ShouldBeEqual() {
        let firstLocation = Location(name: "home")
        let secondLocation = Location(name: "home")
        
        XCTAssertEqual(firstLocation, secondLocation)
    }
    
    func testWhenLatitudeDiffers_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties(firstName: "home", secondName: "home", firstLongLat: (0,0), secondLongLat: (1,0))
    }
    
    func testWhenLongitudeDiffers_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties(firstName: "home", secondName: "home", firstLongLat: (0,0), secondLongLat: (0,1))
    }
   
    func testWhenOneHasCoordinateAndOtherDoesnt_ShouldNoBeEqual() {
        performNotEqualTestWithLocationProperties(firstName: "home", secondName: "home", firstLongLat: nil, secondLongLat: (0,0))
    }
   
    func testWhenNameDiffers_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties(firstName: "home", secondName: "work", firstLongLat: (0,0), secondLongLat: (0,0))
    }
    
    // MARK: Initializer
    
    func testInitShouldSetName() {
        let location = Location(name: "test name")
        
        XCTAssertEqual("test name", location.name, "Initializer should set the name")
    }
    
    func testInit_ShouldSetNameAndCoordinate() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 1,
                                                    longitude: 1)
        let location = Location(name: "",
                                coordinate: testCoordinate)
        
    XCTAssertEqual(testCoordinate.latitude, location.coordinate?.latitude, "Initializer should set latitude")
    
    XCTAssertEqual(testCoordinate.longitude, location.coordinate?.longitude, "Initializer should set longitude")}

}
