//
//  Extensions.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/19/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

typealias Byte = UInt8


extension Int {
    
    var bitSet: [Byte] {
        var result = [UInt8]()
        
        var input  = abs(self)
        while(input > 0) {
            result.append(UInt8(input % 2))
            input = input / 2
        }
        if result.count < 8 {
            for _ in result.count..<8 {
                result.append(0)
            }
        }
        
        return result
    }
    
    var staticHash: Int {
        var hash = Int (5381)
        let buf = [UInt8](String(self).utf8)
        
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + Int(b)
        }
        
        return abs(hash)
    }
    
}

extension String {
    
    var staticHash: Int {
        var hash = Int (5381)
        let buf = [UInt8](self.utf8)
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + Int(b)
        }
        
        return abs(hash)
    }
    
}
