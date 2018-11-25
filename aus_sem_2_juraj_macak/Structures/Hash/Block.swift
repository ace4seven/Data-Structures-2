//
//  Block.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Block<T: Record> {
    
    fileprivate var recordsCount: Int = 0
    
//    fileprivate var offset: UInt64 = 0 // BLOCK ADDRESS
    fileprivate var _records: [T] = []
//    fileprivate let recordSize: Int
    
    var records: [T] {
        get {
            return self._records
        }
    }
    
    init() {
        self.recordsCount = 0
//        self.offset = offset
//        self.recordSize = recordSize
    }
    
    init(bytes: [Byte]) {
        var min = 0
        var max = T.getSize()
        
        for _ in 0..<C.BLOCK_SIZE {
            let recordData = bytes.enumerated().compactMap { ($0 >= min && $0 < max) ? $1 : nil }
            self.recordsCount += 1
            let record: T = T.fromByteArray(recordData) as! T
            min += T.getSize()
            max += T.getSize()
            _records.append(record)
        }
    }
    
}

// MARK: - Public

extension Block {
    
    @discardableResult
    func insert(record: T) -> Bool {
        if recordsCount <= C.BLOCK_SIZE {
            _records.append(record)
            recordsCount += 1
            return true
        }
        print("Potrebny preplnujuci blok")
        return false
    }
    
    static func getSize() -> Int {
        return C.BLOCK_SIZE * T.getSize()
    }
    
    func toByteArray() -> [Byte] {
        var result: [Byte] = []
        
        for record in _records {
            result.append(contentsOf: record.toByteArray())
        }
        
        return result
    }
    
}

// MARK: - Fileprivates

extension Block {
    
    
    
}
