//
//  PropertyByRegionAndNumber.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/1/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class PropertyByRegionAndNumber {
    
    let propertyID: UInt
    let regionName: String
    
    let blockIndex: UInt
    
    init(propertyID: UInt, regionName: String, blockIndex: UInt) {
        self.propertyID = propertyID
        self.regionName = regionName
        self.blockIndex = blockIndex
    }
    
    init(data: [Byte]) {
        let propertyIDData = data.enumerated().compactMap { $0 < 8 ? $1 : nil }
        let regionNameData = data.enumerated().compactMap { $0 >= 8 && $0 < 23 ? $1 : nil }
        let blockIndexData = data.enumerated().compactMap { $0 >= 23 ? $1 : nil }
        
        self.propertyID = ByteConverter.fromByteArray(propertyIDData, UInt.self)
        self.regionName = ByteConverter.fromByteToString(regionNameData).cleanDelimeter(delimeter: ";")
        self.blockIndex = ByteConverter.fromByteArray(blockIndexData, UInt.self)
    }
    
    
}

extension PropertyByRegionAndNumber: Record {
    
    func getHash() -> [Byte] {
        let idHash = Int(propertyID.staticHash)
        let nameHash = regionName.staticHash
        
        let sum = idHash + nameHash
        return sum.bitSet
    }
    
    func toByteArray() -> [Byte] {
        var buffer: [Byte] = []
        
        let propertyIDBytes = ByteConverter.toByteArray(self.propertyID)
        let regionNameBytes = ByteConverter.stringToBytes(self.regionName.modifyTo(size: 15, delimeter: ";"))
        let blockIndexBytes = ByteConverter.toByteArray(self.blockIndex)
        
        buffer.append(contentsOf: propertyIDBytes)
        buffer.append(contentsOf: regionNameBytes)
        buffer.append(contentsOf: blockIndexBytes)
        
        return buffer
    }
    
    static func fromByteArray(_ bytes: [Byte]) -> Any {
        return PropertyByRegionAndNumber(data: bytes)
    }
    
    static func getSize() -> Int {
        return 31
    }
    
    static func == (lhs: PropertyByRegionAndNumber, rhs: PropertyByRegionAndNumber) -> Bool {
        return lhs.propertyID == rhs.propertyID && lhs.regionName == rhs.regionName
    }
    
    
}
