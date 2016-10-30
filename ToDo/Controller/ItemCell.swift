//
//  ItemCell.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 10/23/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    func config(with item: ToDoItem, isChecked: Bool = false) {
        
        if isChecked {
            
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: [NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
            locationLabel.text = nil
            dateLabel.text = nil
            
            return
        }
        
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text  = type(of:self).dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
    }
}
