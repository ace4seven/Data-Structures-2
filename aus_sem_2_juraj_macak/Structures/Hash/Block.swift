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
    fileprivate var _supportingFileOffset: Int64 = -1
    
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
        
        self._supportingFileOffset = ByteConverter.fromByteArray(bytes.enumerated().compactMap { ($0 >= 0 && $0 < 8) ? $1 : nil  }, Int64.self)
        self._recordsCount = bytes[8]
        self._offset = offset
        
        var min = 9
        var max = T.getSize() + 9
        
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
        return UInt64(_maxRecordsCount * T.getSize() + 1 + 8)
    }
    
    func toByteArray() -> [Byte] {
        var result: [Byte] = []
        result.append(contentsOf: ByteConverter.toByteArray(self._supportingFileOffset))
        result.append(_recordsCount)
        for record in _records {
            result.append(contentsOf: record.toByteArray())
        }
        
        return result
    }
    
    func getOffset() -> UInt64? {
        return self._offset
    }
    
    func supportingFileOffset() -> Int64 {
        return self._supportingFileOffset
    }
    
    func setSupportingFileOffset(_ value: Int64) {
        self._supportingFileOffset = value
    }
    
    func copy() -> Block<T> {
        let copy = Block<T>.init(maxRecordsCount: self._maxRecordsCount, offset: self.getOffset())
        copy._records = self.records
        copy._recordsCount = self._recordsCount
        copy._supportingFileOffset = self._supportingFileOffset
        return copy
    }
    
}
