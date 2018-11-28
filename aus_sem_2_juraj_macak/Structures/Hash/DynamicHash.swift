//
//  DynamicHash.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class DynamicHash<T: Record> {
    
    fileprivate let deep: Int
    fileprivate var trie = Trie()
    
    fileprivate let fm: UnFileManager<T>
    
    // BLOCK CACHE
    fileprivate var block: Block<T>?
    fileprivate var blockHelper1: Block<T>?
    fileprivate var blockHelper2: Block<T>?
    
    init(deep: Int, fileManager: UnFileManager<T>) {
        self.deep = deep
        self.fm = fileManager
    }
    
}

// MARK: - Public

extension DynamicHash {
    
    @discardableResult
    func insert(_ record: T) -> Bool {
        let hash = record.getHash()
        
        if trie.root == nil {
            trie.addExternalRoot()
        }
        
        if find(record) == nil {
            let ext = trie.find(bitset: record.getHash())
            
            block = fm.mainFile.getBlock(address: ext.blockAddress, for: .main)
            if block!.insert(record: record, for: .main) {
                fm.mainFile.insert(block: block!, address: ext.blockAddress)
                return true
            }
            
            if hash.count < self.deep {
                // TODO: PREPLNUJUCE SUBORY
            } else {
                blockHelper1 = Block<T>.init()
            }
        } // In other case file exist
        
        
        return false
    }
    
    func find(_ record: T) -> T? {
        let ext = trie.find(bitset: record.getHash())
        block = fm.mainFile.getBlock(address: ext.blockAddress, for: .main)
        
        // TODO - Preplnujuci blok
        
        for item in self.block!.records {
            if item == record {
                return item
            }
        }
        
        return nil
    }
    
}

// MARK: - Privates

extension DynamicHash {
    
}
