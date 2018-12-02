//
//  PropertyCell.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {

    @IBOutlet weak var uniqueIDLabel: UILabel!
    @IBOutlet weak var propertyIDLabel: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var propertyICO: UIImageView!
    
    func setupCell(property: Property) {
        self.uniqueIDLabel.text = "\(property.uniqueID)"
        self.propertyIDLabel.text = "\(property.propertyID)"
        self.regionNameLabel.text = property.regionName
        self.descLabel.text = property.desc
    }

}
