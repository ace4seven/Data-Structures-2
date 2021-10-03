//
//  ByteConverter.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/24/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class ByteConverter {
    
    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
    
    static func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }
    
    static func fromByteToString(_ value: [UInt8]) -> String {
        return String(bytes: value, encoding: String.Encoding.utf8)!
    }
    
    static func stringToBytes(_ value: String) -> [Byte] {
        let result: [Byte] = Array(value.utf8)
        return result
    }
    
}
