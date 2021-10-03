//
//  PropertyUniqueCell.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class PropertyUniqueCell: UITableViewCell {

    @IBOutlet weak var uniqueIDLabel: UILabel!
    @IBOutlet weak var blockIndexLabel: UILabel!
    
    func setupCell(property: PropertyByUnique) {
        self.uniqueIDLabel.text = "\(property.uniqueID)"
        self.blockIndexLabel.text = "\(property.blockIndex)"
    }

}
