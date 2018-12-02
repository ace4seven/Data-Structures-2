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
        
        self.dynamicHashUnique = DynamicHash<PropertyByUnique>.init(deep: config?.deep ?? 10, mainFileSize: config?.mainFileSize ?? 4, supportFileSize: config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByUnique>.init(mainFileName: "properties_unique", supportingFileName: "properties_unique_sp"))
        self.dynamicHashRnamePId = DynamicHash<PropertyByRegionAndNumber>.init(deep:  config?.deep ?? 10, mainFileSize:  config?.mainFileSize ?? 4, supportFileSize:  config?.supportFileSize ?? 2, fileManager: UnFileManager<PropertyByRegionAndNumber>.init(mainFileName: "properties_reg", supportingFileName: "properties_reg_sp"))
    }

    fileprivate let unOrderedFile = UnorderedFile<Property>(fileName: "properties")
    fileprivate var dynamicHashUnique: DynamicHash<PropertyByUnique>
    fileprivate var dynamicHashRnamePId: DynamicHash<PropertyByRegionAndNumber>
    fileprivate var freeIndex: UInt = 0
    fileprivate var config: Config?
    
    fileprivate var block: Block<Property>?
    
}

// MARK: - PUBLIC

extension CoreHash {
    
    func getPropertiesFromFile() -> [Block<Property>] {
        var result: [Block<Property>] = []
        
        for i in 0...freeIndex {
            let block = unOrderedFile.getBlock(offset: UInt64(i), maxRecordsCount: config?.mainFileSize ?? 4)
            result.append(block)
        }
        
        return result
    }
    
    func getPropertiesRegionNamePropertyID() -> [Block<PropertyByRegionAndNumber>] {
        var result: [Block<PropertyByRegionAndNumber>] = []
        
        dynamicHashRnamePId.traverseMainFile { block in
            result.append(block)
        }
        
        dynamicHashRnamePId.traverseSupportFile { block in
            result.append(block)
        }
        
        return result
    }
    
    func getPropertiesUnique() -> [Block<PropertyByUnique>] {
        var result: [Block<PropertyByUnique>] = []
        
        dynamicHashUnique.traverseMainFile { block in
            result.append(block)
        }
        
        dynamicHashUnique.traverseSupportFile { block in
            result.append(block)
        }
        
        return result
    }
    
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
                if self.block!.records.count < self.config?.mainFileSize ?? 4 {
                    self.block!.insert(record: property)
                } else {
                    freeIndex += 1
                    self.block = Block<Property>.init(maxRecordsCount: self.config?.mainFileSize ?? 4, offset: UInt64(freeIndex))
                    self.block!.insert(record: property)
                    propertyUnique.blockIndex = freeIndex
                    propertyRegAndID.blockIndex = freeIndex
                }
            } else {
                self.block = Block<Property>.init(maxRecordsCount: self.config?.mainFileSize ?? 4, offset: UInt64(freeIndex))
                self.block?.insert(record: property)
            }
            dynamicHashUnique.insert(propertyUnique)
            dynamicHashRnamePId.insert(propertyRegAndID)
        } else {
            return false
        }
        
        unOrderedFile.insert(block: self.block!, address: UInt64(freeIndex) * block!.getSize())
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
    
    func generateProperties(count: Int, completion: @escaping () -> ()) {
        var index = count
        var uniqueIndex = 1
        let numberOfPropertiesInRegion = count / RegionNamesStorage.names.count + 10
        while index > 0 {
            var property = Property(uniqueID: UInt(uniqueIndex),
                                    propertyID: UInt.random(in: 1..<UInt(numberOfPropertiesInRegion)),
                                    regionName: RegionNamesStorage.names[Int.random(in: 0..<RegionNamesStorage.names.count)],
                                    desc: PropertyDescStorage.words[Int.random(in: 0..<PropertyDescStorage.words.count)])
            while insertProperty(property: property) == false {
                property = Property(uniqueID: UInt(uniqueIndex),
                                    propertyID: UInt.random(in: 1...UInt(numberOfPropertiesInRegion)),
                                    regionName: RegionNamesStorage.names[Int.random(in: 0..<RegionNamesStorage.names.count)],
                                    desc: PropertyDescStorage.words[Int.random(in: 0..<PropertyDescStorage.words.count)])
            }
            
            uniqueIndex += 1
            index -= 1
        }
        
        completion()
        print("Generovanie uspesne")
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
