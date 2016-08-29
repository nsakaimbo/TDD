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
