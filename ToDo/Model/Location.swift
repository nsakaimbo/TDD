//
//  Location.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 8/29/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import CoreLocation

struct Location: Equatable {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
    
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    
    var plistDict: NSDictionary {
   
        var dict = [String:AnyObject]()
        
        dict[nameKey] = name as NSString
    
        if let coordinate = coordinate {
            dict[latitudeKey] = coordinate.latitude as NSNumber
            dict[longitudeKey] = coordinate.longitude as NSNumber
        }
        
        return dict as NSDictionary
    }
    
    init?(dict: NSDictionary) {
        guard let name = dict[nameKey] as? String else {
            return nil
        }
        
        let coordinate: CLLocationCoordinate2D?
        
        if let latitude = dict[latitudeKey] as? Double,
            let longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        self.name = name
        self.coordinate = coordinate
    }
}

func == (lhs: Location, rhs: Location) -> Bool {
   
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude { return false }
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude { return false }
    if lhs.name != rhs.name { return false }
    
    return true
}
