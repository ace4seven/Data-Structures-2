//
//  ActionsViewDelegate.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

protocol ActionsVM: class {
    func setup(viewDelegate: ActionsViewDelegate)
    
    func searchByUnique(id: UInt)
    func searchByNameAndId(regionName: String, propertyID: UInt)
    func addProperty(property: Property)
}

protocol ActionsViewDelegate: class {
    func showAlert(message: ActionMessage)
    func showDetail(property: Property)
}
