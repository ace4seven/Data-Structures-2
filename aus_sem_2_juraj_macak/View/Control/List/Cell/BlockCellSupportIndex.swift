//
//  BlockCellSupportIndex.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/4/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

import UIKit

class BlockCellSupportIndex: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var supportIndexLabel: UILabel!
    
    func setupCell(address: String, supportIndex: Int64) {
        self.addressLabel.text = address
        self.supportIndexLabel.text = "\(supportIndex)"
    }
    
}

