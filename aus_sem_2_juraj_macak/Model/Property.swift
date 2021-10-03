//
//  Property.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Property {
    
    let uniqueID: UInt
    let propertyID: UInt
    let regionName: String
    var desc: String
    
    init(uniqueID: UInt,
         propertyID: UInt,
         regionName: String, // MAX 15
         desc: String  // MAX 20
        ) {
        
        self.uniqueID = uniqueID
        self.propertyID = propertyID
        self.regionName = regionName
        self.desc = desc
    }
    
    init(data: [Byte]) {
        let uniqueIDData = data.enumerated().compactMap { $0 < 8 ? $1 : nil }
        let propertyData = data.enumerated().compactMap { $0 >= 8 && $0 < 16 ? $1 : nil }
        let nameData = data.enumerated().compactMap { $0 >= 16 && $0 < 31 ? $1 : nil }
        let descData = data.enumerated().compactMap { $0 >= 31 ? $1 : nil }
        
        self.uniqueID = ByteConverter.fromByteArray(uniqueIDData, UInt.self)
        self.propertyID = ByteConverter.fromByteArray(propertyData, UInt.self)
        self.regionName = ByteConverter.fromByteToString(nameData).cleanDelimeter(delimeter: ";")
        self.desc = ByteConverter.fromByteToString(descData).cleanDelimeter(delimeter: ";")
    }
    
    func debugPrint() {
        print("     uniqueID:   \(self.uniqueID)")
        print("     regionName: \(self.regionName)")
        print("     propertyID: \(self.propertyID)")
        print("     desc:       \(self.desc)")
    }
    
}

extension Property: Record {

    func getHash() -> [Byte] {
        return self.uniqueID.staticHash.bitSet
    }

    func toByteArray() -> [Byte] {
        var buffer: [Byte] = []
        
        let uniqueIDBytes = ByteConverter.toByteArray(self.uniqueID)
        let propertyIDBytes = ByteConverter.toByteArray(self.propertyID)
        let regionNameBytes = ByteConverter.stringToBytes(self.regionName.modifyTo(size: 15, delimeter: ";")) // 16 bytes
        let descBytes = ByteConverter.stringToBytes(self.desc.modifyTo(size: 20, delimeter: ";")) // 16 bytes
        
        buffer.append(contentsOf: uniqueIDBytes)
        buffer.append(contentsOf: propertyIDBytes)
        buffer.append(contentsOf: regionNameBytes)
        buffer.append(contentsOf: descBytes)
        
        return buffer
    }

    static func fromByteArray(_ bytes: [Byte]) -> Any {
        return Property(data: bytes)
    }

    static func getSize() -> Int {
        return 16 + 35
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        return lhs.uniqueID == rhs.uniqueID
    }

}
