//
//  ActionsViewModel.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

enum ActionMessage {
    case notFound
    case duplicity
    
    var value: String {
        switch self {
        case .notFound:
            return "Nehnuteľnosť sa nenašla"
        case .duplicity:
            return "Položku sa nepodarilo pridať, pretože už existuje s daným kľúčom"
        }
    }
}

class ActionsViewModel {
    
    fileprivate weak var viewDelegate: ActionsViewDelegate?
    
}

extension ActionsViewModel: ActionsVM {
    
    func addProperty(property: Property) {
        if CoreHash.shared.insertProperty(property: property) {
            viewDelegate?.showDetail(property: property)
        } else {
            viewDelegate?.showAlert(message: .duplicity)
        }
    }
    
    func searchByUnique(id: UInt) {
        if let property = CoreHash.shared.searchProperty(uniqueID: id) {
            viewDelegate?.showDetail(property: property)
        } else {
            viewDelegate?.showAlert(message: .notFound)
        }
    }
    
    func searchByNameAndId(regionName: String, propertyID: UInt) {
        if let property = CoreHash.shared.searchProperty(propertyByNameAndID: PropertyByRegionAndNumber(propertyID: propertyID, regionName: regionName, blockIndex: 0)) {
            viewDelegate?.showDetail(property: property)
        } else {
            viewDelegate?.showAlert(message: .notFound)
        }
    }
    
    
    func setup(viewDelegate: ActionsViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
}
