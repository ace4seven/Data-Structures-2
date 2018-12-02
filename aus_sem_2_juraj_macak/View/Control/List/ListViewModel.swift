//
//  ListViewModel.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class ListViewModel {
    
    fileprivate weak var viewDelegate: ListViewDelegate?
    fileprivate let type: ListType
    
    init(type: ListType) {
        self.type = type
    }
    
}

extension ListViewModel: ListVM {
    
    func setup(viewDelegate: ListViewDelegate) {
        self.viewDelegate = viewDelegate
        
        var items = [ListItemType]()
        
        switch type {
        case .property:
            let blocks = CoreHash.shared.getPropertiesFromFile()
            for block in blocks {
                items.append(.block(address: "\(block.getOffset()! * block.getSize())"))
                for record in block.records {
                    items.append(.property(property: record))
                }
            }
        case .propertyUnique:
            let blocks = CoreHash.shared.getPropertiesUnique()
            for block in blocks {
                items.append(.block(address: "\(block.getOffset()! * block.getSize())"))
                for record in block.records {
                    items.append(.propertyUnique(record))
                }
            }
            
        case .propertyRegionNumber:
            let blocks = CoreHash.shared.getPropertiesRegionNamePropertyID()
            for block in blocks {
                items.append(.block(address: "\(block.getOffset()! * block.getSize())"))
                for record in block.records {
                    items.append(.propertyNameNumber(record))
                }
            }
        }
        
        viewDelegate.showItems(items: items, for: type)
    }
    
}
