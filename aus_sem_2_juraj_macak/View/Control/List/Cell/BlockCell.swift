//
//  BlockCell.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class BlockCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    
    func setupCell(address: String) {
        self.addressLabel.text = address
    }

}
