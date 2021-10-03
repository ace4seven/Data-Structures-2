//
//  PropertyRegionNumberCell.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class PropertyRegionNumberCell: UITableViewCell {

    @IBOutlet weak var propertyIDLabel: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var blockIndexLabel: UILabel!
    
    func setupCell(property: PropertyByRegionAndNumber) {
        propertyIDLabel.text = "\(property.propertyID)"
        regionNameLabel.text = property.regionName
        blockIndexLabel.text = "\(property.blockIndex)"
    }

}
