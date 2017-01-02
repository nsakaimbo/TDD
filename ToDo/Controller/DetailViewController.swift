//
//  DetailViewController.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/6/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import MapKit
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    var itemInfo: (ItemManager, Int)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemInfo = itemInfo else {
            fatalError("Error. Item Info not set for DetailViewController.")
        }
        
        let item = itemInfo.0.itemAtIndex(itemInfo.1)
        
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dueDateLabel.text = type(of: self).dateFormatter.string(from: date)
        } else {
            dueDateLabel.text = nil
        }
        
        if let coordinate = item.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }
    
    func checkItem() {
        guard let itemInfo = itemInfo else {
            fatalError("Error. Item Info not set for DetailViewController.")
        }
        
        itemInfo.0.checkItemAtIndex(itemInfo.1)
    }
}
