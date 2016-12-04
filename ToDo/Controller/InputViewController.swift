//
//  InputViewController.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/10/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import CoreLocation
import UIKit

fileprivate extension Selector {
    static let save = #selector(InputViewController.save)
}

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    var itemManager: ItemManager?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.addTarget(self, action: .save, for: .touchUpInside)
    }
    
    // Methods
    /// Adds an item to the ItemManager
    func save() {
        
        guard let title = titleTextField.text,
            !title.isEmpty else { return }
        
        let date: Date?
        if let dateText = dateTextField.text,
            !dateText.isEmpty {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        
        let description: String?
        if let descriptionText = descriptionTextField.text,
            !descriptionText.isEmpty {
            description = descriptionText
        } else {
            description = nil
        }
        
        if let locationName = locationTextField.text,
            !locationName.isEmpty {
            
            // Save Location with title and coordinate
            if let address = addressTextField.text,
                !address.isEmpty {
                
                geocoder.geocodeAddressString(address) { (placeMarks, error) in
                    
                    let placeMark = placeMarks?.first
                    
                    let item = ToDoItem(title: title, itemDescription: description, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                    
                    self.itemManager?.addItem(item)
                }
            } else {
                // Save Location with title only
                let item = ToDoItem(title: title, itemDescription: description, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: nil))
                
                self.itemManager?.addItem(item)
            }
        } else {
            // Save ToDoItem with no Location
            let item = ToDoItem(title: title, itemDescription: description, timestamp: date?.timeIntervalSince1970, location: nil)
            
            self.itemManager?.addItem(item)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
