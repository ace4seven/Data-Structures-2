//
//  PropertyByUnique.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/1/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class PropertyByUnique {
    
    let uniqueID: UInt
    var blockIndex: UInt
    
    init(data: [Byte]) {
        let uniqueIDData = data.enumerated().compactMap { $0 < 8 ? $1 : nil }
        let blockIndexData = data.enumerated().compactMap { $0 >= 8 ? $1 : nil }
        
        self.uniqueID = ByteConverter.fromByteArray(uniqueIDData, UInt.self)
        self.blockIndex = ByteConverter.fromByteArray(blockIndexData, UInt.self)
    }
    
    init(uniqueID: UInt, blockIndex: UInt) {
        self.uniqueID = uniqueID
        self.blockIndex = blockIndex
    }
    
}

extension PropertyByUnique: Record {
    
    func getHash() -> [Byte] {
        return uniqueID.staticHash.bitSet
    }
    
    func toByteArray() -> [Byte] {
        var buffer: [Byte] = []
        
        let uniqueIDBytes = ByteConverter.toByteArray(self.uniqueID)
        let blockIndex = ByteConverter.toByteArray(self.blockIndex)
        
        buffer.append(contentsOf: uniqueIDBytes)
        buffer.append(contentsOf: blockIndex)
        
        return buffer
    }
    
    static func fromByteArray(_ bytes: [Byte]) -> Any {
        return PropertyByUnique(data: bytes)
    }
    
    static func getSize() -> Int {
        return 16
    }
    
    static func == (lhs: PropertyByUnique, rhs: PropertyByUnique) -> Bool {
        return lhs.uniqueID == rhs.uniqueID
    }
    
    
}
