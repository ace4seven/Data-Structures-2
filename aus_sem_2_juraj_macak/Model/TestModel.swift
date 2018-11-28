//
//  TestModel.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/23/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class TestModel {
    
    let id: Int
    let desc: String
    
    init(id: Int, desc: String) {
        self.id = id
        self.desc = desc
    }
    
    init(data: [Byte]) {
        let idData = data.enumerated().compactMap { $0 < 4 ? $1 : nil }
        let descData = data.enumerated().compactMap { $0 >= 4 ? $1 : nil }
        self.id = ByteConverter.fromByteArray(idData, Int.self)
        self.desc = ByteConverter.fromByteToString(descData)
    }
    
}

extension TestModel: Record {

    func getHash() -> [UInt8] {
        let idHash = id.staticHash
        let descHash = desc.staticHash
        
        let sum = idHash + descHash
        return sum.bitSet
    }
    
    func toByteArray() -> [Byte] {
        var buffer: [Byte] = []
        
        let idBytes = ByteConverter.toByteArray(self.id)
        let descBytes = ByteConverter.stringToBytes(self.desc)
        
        buffer.append(contentsOf: idBytes)
        buffer.append(contentsOf: descBytes)
        
        return buffer
    }
    
    static func fromByteArray(_ bytes: [Byte]) -> Any {
        return TestModel(data: bytes)
    }
    
    static func getSize() -> Int {
        return 20 // 16 bytes for string, 4 bytes for ID
    }
    
    static func == (lhs: TestModel, rhs: TestModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
