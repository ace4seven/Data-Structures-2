//
//  PropertyDetailController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class PropertyDetailController: UIViewController {
    
    @IBOutlet weak var uniqueIDLabel: UILabel!
    
    @IBOutlet weak var propertyIDLabel: UILabel!
    
    @IBOutlet weak var regionNameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var property: Property?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let property = self.property else {
            return
        }
        
        uniqueIDLabel.text = "\(property.uniqueID)"
        propertyIDLabel.text = "\(property.propertyID)"
        regionNameLabel.text = property.regionName
        descLabel.text = property.desc
    }


}
