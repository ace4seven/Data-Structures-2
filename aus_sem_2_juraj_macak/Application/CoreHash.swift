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
        
        self.config = Config()
        
        if config == nil {
            Config.saveNewConfig(mainFileSize: 4, supportFileSize: 2, deep: 10)
            self.config = Config()
        }
        
        self.dynamicHashUnique = DynamicHash<PropertyByUnique>.init(deep: config?.deep ?? 10, mainFileSize: config?.mainFileSize ?? 4, supportFileSize: config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByUnique>.init(mainFileName: "properties_unique_bin", supportingFileName: "properties_unique_sp_bin"))
        self.dynamicHashRnamePId = DynamicHash<PropertyByRegionAndNumber>.init(deep:  config?.deep ?? 10, mainFileSize:  config?.mainFileSize ?? 4, supportFileSize:  config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByRegionAndNumber>.init(mainFileName: "properties_reg_bin", supportingFileName: "properties_reg_sp_bin"))
    }

    fileprivate let unOrderedFile = UnorderedFile<Property>(fileName: "properties_bin")
    fileprivate var dynamicHashUnique: DynamicHash<PropertyByUnique>
    fileprivate var dynamicHashRnamePId: DynamicHash<PropertyByRegionAndNumber>
    fileprivate var freeIndex: UInt = 0
    fileprivate var config: Config?
    
    fileprivate var block: Block<Property>?
    
}

// MARK: - PUBLIC

extension CoreHash {
    
    func changeConfig(mainFileSize: Int, supportFileSize: Int, deep: Int) {
        Config.saveNewConfig(mainFileSize: mainFileSize, supportFileSize: supportFileSize, deep: deep)
        self.config = Config()
        
        self.dynamicHashUnique = DynamicHash<PropertyByUnique>.init(deep: config?.deep ?? 10, mainFileSize: config?.mainFileSize ?? 4, supportFileSize: config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByUnique>.init(mainFileName: "properties_unique_bin", supportingFileName: "properties_unique_sp_bin"))
        self.dynamicHashRnamePId = DynamicHash<PropertyByRegionAndNumber>.init(deep:  config?.deep ?? 10, mainFileSize:  config?.mainFileSize ?? 4, supportFileSize:  config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByRegionAndNumber>.init(mainFileName: "properties_reg_bin", supportingFileName: "properties_reg_sp_bin"))
        
        block = nil
        freeIndex = 0
    }
    
    func insertProperty(property: Property) -> Bool {
        
        let propertyRegAndID = PropertyByRegionAndNumber(propertyID: property.propertyID, regionName: property.regionName, blockIndex: freeIndex)
        let propertyUnique = PropertyByUnique(uniqueID: property.uniqueID, blockIndex: freeIndex)
        
        if dynamicHashUnique.find(propertyUnique) == nil && dynamicHashRnamePId.find(propertyRegAndID) == nil {
            if let block = self.block {
                if block.records.count < self.config?.mainFileSize ?? 4 {
                    block.insert(record: property)
                } else {
                    freeIndex += 1
                    self.block = Block<Property>.init(maxRecordsCount: self.config?.mainFileSize ?? 4, offset: UInt64(freeIndex))
                    propertyUnique.blockIndex = freeIndex
                    propertyRegAndID.blockIndex = freeIndex
                }
            } else {
                block = Block<Property>.init(maxRecordsCount: self.config?.mainFileSize ?? 4, offset: UInt64(freeIndex))
            }
            dynamicHashUnique.insert(propertyUnique)
            dynamicHashRnamePId.insert(propertyRegAndID)
        } else {
            return false
        }
        
        unOrderedFile.insert(block: self.block!, address: UInt64(freeIndex))
        return true
    }
    
    func searchProperty(uniqueID: UInt) -> Property? {
        guard let propertyByUnique = dynamicHashUnique.find(PropertyByUnique(uniqueID: uniqueID, blockIndex: 0)) else {
            return nil
        }
        
        for item in unOrderedFile.getBlock(offset: UInt64(propertyByUnique.blockIndex), maxRecordsCount: config!.mainFileSize!).records {
            if item.uniqueID == uniqueID {
                return item
            }
        }
        
        print("Error with searching, should be nill")
        return nil
    }
    
    func searchProperty(propertyByNameAndID: PropertyByRegionAndNumber) -> Property? {
        guard let propertyByRegionNameAndID = dynamicHashRnamePId.find(propertyByNameAndID) else {
            return nil
        }
        
        for item in unOrderedFile.getBlock(offset: UInt64(propertyByRegionNameAndID.blockIndex), maxRecordsCount: config!.mainFileSize!).records {
            if item.regionName == propertyByNameAndID.regionName && item.propertyID == propertyByNameAndID.propertyID {
                return item
            }
        }
        
        print("Error with searching, should be nill")
        return nil
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
