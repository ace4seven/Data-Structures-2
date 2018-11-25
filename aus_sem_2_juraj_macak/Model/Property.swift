//
//  Property.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Property {
    
    let regionID: UInt
    let propertyID: UInt
    let name: String
    let desc: String
    
    init(regionID: UInt, propertyID: UInt, name: String, desc: String) {
        self.regionID = regionID
        self.propertyID = propertyID
        self.name = name
        self.desc = desc
    }
    
}

//extension Property: Record {
//    
//    static func == (lhs: Property, rhs: Property) -> Bool {
//        return lhs.propertyID == rhs.propertyID
//    }
//    
//    
//    func getHash() -> BitSet {
//        return BitSet(size: 10)
//    }
//    
//    
//    func toByteArray() {
//        
//    }
//    
//    func fromByteArray() {
//        
//    }
//    
//    func getSize() -> Int {
//        return 0
//    }
//    
//    
//}
