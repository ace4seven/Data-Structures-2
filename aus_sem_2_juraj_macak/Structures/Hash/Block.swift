//
//  Block.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Block<T: Record> {
    
    fileprivate var _recordsCount: Int = 0
    fileprivate var _records: [T] = []
    
    var records: [T] {
        get {
            return self._records
        }
    }
    
    init() {
        self._recordsCount = 0
    }
    
    init(bytes: [Byte], for fileType: FileTypeSize) {
        var min = 0
        var max = T.getSize()
        
        for _ in 0..<fileType.size {
            let recordData = bytes.enumerated().compactMap { ($0 >= min && $0 < max) ? $1 : nil }
            self._recordsCount += 1
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
    func insert(record: T, for fileType: FileTypeSize) -> Bool {
        if _recordsCount <= fileType.size {
            _records.append(record)
            _recordsCount += 1
            return true
        }
        print("Potrebny preplnujuci blok")
        return false
    }
    
    static func getSize(for fileType: FileTypeSize) -> Int {
        return fileType.size * T.getSize()
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
