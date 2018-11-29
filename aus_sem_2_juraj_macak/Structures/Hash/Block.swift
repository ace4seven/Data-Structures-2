//
//  Block.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Block<T: Record> {
    
    fileprivate var _recordsCount: UInt8 = 0
    fileprivate var _records: [T] = []
    fileprivate let _maxRecordsCount: Int
    fileprivate var _offset: UInt64?
    
    var records: [T] {
        get {
            return self._records
        }
    }
    
    init(maxRecordsCount: Int, offset: UInt64? = nil) {
        self._recordsCount = 0
        self._maxRecordsCount = maxRecordsCount
        self._offset = offset
    }
    
    init(bytes: [Byte], maxRecordsCount: Int, offset: UInt64) {
        self._maxRecordsCount = maxRecordsCount
        self._recordsCount = bytes[0]
        self._offset = offset
        
        var min = 1
        var max = T.getSize() + 1
        
        for _ in 0..<_recordsCount {
            let recordData = bytes.enumerated().compactMap { ($0 >= min && $0 < max) ? $1 : nil }
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
        if _recordsCount < _maxRecordsCount {
            _records.append(record)
            _recordsCount += 1
            return true
        }
        return false
    }
    
    func getSize() -> UInt64 {
        return UInt64(_maxRecordsCount * T.getSize() + 1)
    }
    
    func toByteArray() -> [Byte] {
        var result: [Byte] = []
        result.append(_recordsCount)
        
        for record in _records {
            result.append(contentsOf: record.toByteArray())
        }
        
        return result
    }
    
    func getOffset() -> UInt64? {
        return self._offset
    }
    
}

// MARK: - Fileprivates

extension Block {
    
    
    
}
