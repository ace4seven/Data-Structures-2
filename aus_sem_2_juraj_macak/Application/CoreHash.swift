//
//  CoreHash.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/1/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class CoreHash {
    
    public static let shared = CoreHash()
    private init() {
        self.dynamicHashUnique = DynamicHash<PropertyByUnique>.init(deep: 20, mainFileSize: 4, supportFileSize: 3, fileManager: UnFileManager<PropertyByUnique>.init(mainFileName: "properties_unique_bin", supportingFileName: "properties_unique_sp_bin"))
        self.dynamicHashRnamePId = DynamicHash<PropertyByRegionAndNumber>.init(deep: 20, mainFileSize: 6, supportFileSize: 4, fileManager: UnFileManager<PropertyByRegionAndNumber>.init(mainFileName: "properties_reg_bin", supportingFileName: "properties_reg_sp_bin"))
    }

    fileprivate let unOrderedFile = UnorderedFile<Property>(fileName: "properties_bin")
    fileprivate let dynamicHashUnique: DynamicHash<PropertyByUnique>
    fileprivate let dynamicHashRnamePId: DynamicHash<PropertyByRegionAndNumber>
    
    fileprivate var freeIndex = 0
    
}

// MARK: - PUBLIC

extension CoreHash {
    
    func insertProperty(property: Property) -> Bool {
        
        return false
    }
    
    func searchProperty(uniqueID: UInt) -> Property? {
        
        return nil
    }
    
    func searchProperty(regionName: String, propertyID: UInt) -> Property? {
        
        return nil
    }
    
    func editProperty(oldProperty: Property, newProperty: Property) -> Bool {
        
        return false
    }
    
    func backupSystem() -> Bool {
        
        return false
    }
    
    func recoverSystem() -> Bool {
        
        return false
    }
    
    
}

// MARK: - PRIVATES

extension CoreHash {
    
}
