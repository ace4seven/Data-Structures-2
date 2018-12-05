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
    case backupComplete
    case loadComplete
    
    var value: String {
        switch self {
        case .notFound:
            return "Nehnuteľnosť sa nenašla"
        case .duplicity:
            return "Položku sa nepodarilo pridať, pretože už existuje s daným kľúčom"
        case .backupComplete:
            return "Záloha operačnej pamäte prebehla úspešne"
        case .loadComplete:
            return "Obnova operačnej pamäte prebehla úspešne"
            
        }
    }
}

class ActionsViewModel {
    
    fileprivate weak var viewDelegate: ActionsViewDelegate?
    
}

extension ActionsViewModel: ActionsVM {
    
    func loadMemory() {
        if CoreHash.shared.recoverSystem() {
            viewDelegate?.showAlert(message: .loadComplete)
        }
    }
    
    func backup() {
        if CoreHash.shared.backupSystem() {
            viewDelegate?.showAlert(message: .backupComplete)
        }
    }
    
    func changeDesc(propertyUnique: UInt, desc: String) {
        if let property = CoreHash.shared.changePropertyDesc(uniqueID: propertyUnique, desc: desc) {
            viewDelegate?.showDetail(property: property)
        } else {
            viewDelegate?.showAlert(message: .notFound)
        }
    }
    
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
