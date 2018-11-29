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
    fileprivate var mainFileSize: Int
    fileprivate var supportFileSize: Int
    
    fileprivate var maxBlockInMainFile: Int? = nil
    fileprivate var maxBlockInSupportFile: Int? = nil
    
//    fileprivate var freeAddress: UInt64? = nil
//    fileprivate var currentMaxAddress: UInt64 = 0
    
    fileprivate var freeOffset: UInt64 = 0
    fileprivate var freeSupportingOffset: Int64 = 0

    
    init(deep: Int, mainFileSize: Int, supportFileSize: Int, fileManager: UnFileManager<T>) {
        self.deep = deep
        self.fm = fileManager
        self.mainFileSize = mainFileSize
        self.supportFileSize = supportFileSize
        self.block = Block<T>.init(maxRecordsCount: mainFileSize, offset: 0)
    }
    
    init(deep: Int, mainFileSize: Int, supportFileSize: Int, maxBlockMainFile: Int, maxBlockSupportFile: Int, fileManager: UnFileManager<T>) {
        self.deep = deep
        self.fm = fileManager
        self.mainFileSize = mainFileSize
        self.supportFileSize = supportFileSize
        
        self.maxBlockInMainFile = maxBlockMainFile
        self.maxBlockInSupportFile = maxBlockSupportFile
    }
    
}

// MARK: - Public

extension DynamicHash {
    
    @discardableResult
    func insert(_ record: T) -> Bool {

        if trie.root == nil {
            trie.addExternalRoot(offset: freeOffset)
            freeOffset += 1
            if block!.insert(record: record) {
                fm.mainFile.insert(block: block!, address: block!.getOffset()! * block!.getSize())
                return true
            }
        }
        
        var ext = trie.find(bitset: record.getHash())
        
        if let offset = ext.offset {
            block = fm.mainFile.getBlock(offset: offset, maxRecordsCount: mainFileSize)
            // TODO - Preplnujuci blok
            
            for item in self.block!.records {
                if item == record {
                    return false
                }
            }
        } else {
            ext.offset = freeOffset
            block = Block<T>.init(maxRecordsCount: mainFileSize, offset: freeOffset)
            block?.insert(record: record)
            fm.mainFile.insert(block: block!, address: freeOffset * block!.getSize())
            freeOffset += 1
            return true
        }
        
        if block!.insert(record: record) {
            fm.mainFile.insert(block: block!, address: block!.getOffset()! * block!.getSize())
            return true
        }
        
        var cycle = true
        while(cycle) {
            if ext.getDeep() >= self.deep {
                return false
                if block?.supportingFileOffset() == -1 {
                    block?.setSupportingFileOffset(freeSupportingOffset)
                    blockHelper1 = Block<T>.init(maxRecordsCount: supportFileSize)
                    blockHelper1?.insert(record: record)
                    
                    fm.supportingFile.insert(block: blockHelper1!, address: UInt64(freeSupportingOffset) * blockHelper1!.getSize())
                    fm.mainFile.insert(block: block!, address: block!.getOffset()! * block!.getSize())
                    freeSupportingOffset += 1
                    return true
                } else {
                    blockHelper1 = fm.supportingFile.getBlock(offset: UInt64(block!.supportingFileOffset()), maxRecordsCount: supportFileSize)
                    if blockHelper1!.records.count < supportFileSize {
                        blockHelper1?.insert(record: record)
                        fm.supportingFile.insert(block: blockHelper1!, address: UInt64(blockHelper1!.supportingFileOffset()) * blockHelper1!.getSize())
                        return true
                    } else {
                        if blockHelper1?.supportingFileOffset() == -1 {
                            blockHelper2 = Block<T>.init(maxRecordsCount: supportFileSize)
                            blockHelper1?.setSupportingFileOffset(freeSupportingOffset)
                            fm.supportingFile.insert(block: blockHelper2!, address:  UInt64(freeSupportingOffset) * blockHelper2!.getSize())
                            fm.supportingFile.insert(block: blockHelper1!, address:  UInt64(block!.supportingFileOffset()) * blockHelper1!.getSize())
                            freeSupportingOffset += 1
                            return true
                        } else {
                            blockHelper1 = fm.supportingFile.getBlock(offset: UInt64(blockHelper1!.supportingFileOffset()), maxRecordsCount: supportFileSize)
                        }
                    }
                }
            } else {
                
                blockHelper1 = Block<T>(maxRecordsCount: self.mainFileSize, offset: block?.getOffset())
                blockHelper2 = Block<T>(maxRecordsCount: self.mainFileSize, offset: freeOffset)
                
                let ex1 = ExternalNode(offset: block?.getOffset()) // Default, main address
                let ex2 = ExternalNode(offset: freeOffset)
                
                trie.increaseTreeNodes(ex1: ex1, ex2: ex2, extCurrent: ext)
                
                ex1.offset = nil
                ex2.offset = nil
                
                // MARK: - Reorganizácia blokov
                
                var firstAdded = false
                for item in self.block!.records {
                    let ext = trie.find(bitset: item.getHash())
                    
                    if ext.offset == nil {
                        ext.offset = firstAdded ? blockHelper2?.getOffset() : blockHelper1?.getOffset()
                        if firstAdded {
                            blockHelper2?.insert(record: item)
                        } else {
                            blockHelper1?.insert(record: item)
                        }
                        firstAdded = true
                    } else {
                        if ext.offset == blockHelper1?.getOffset() {
                            blockHelper1?.insert(record: item)
                        } else {
                            blockHelper2?.insert(record: item)
                        }
                    }
                }
                
                ext = trie.find(bitset: record.getHash())
                
                if ext.offset == nil {
                    ext.offset = freeOffset
                    if blockHelper2!.insert(record: record) {
                        freeOffset += 1
                        cycle = false
                        break
                    }
                }
                
                if(blockHelper1!.getOffset() == ext.offset!) {
                    if blockHelper1!.insert(record: record) {
                        cycle = false
                        freeOffset += 1
                        break
                    }
                } else if(blockHelper2!.getOffset() == ext.offset!) {
                    if blockHelper2!.insert(record: record) {
                        cycle = false
                        freeOffset += 1
                        break
                    }
                }
                
            }
        }
        
        fm.mainFile.insert(block: blockHelper1!, address: blockHelper1!.getOffset()! * blockHelper1!.getSize())
        fm.mainFile.insert(block: blockHelper2!, address: blockHelper2!.getOffset()! * blockHelper2!.getSize())
        
        return true
    }
    
    func find(_ record: T) -> T? {
        let ext = trie.find(bitset: record.getHash())
        if let offset = ext.offset {
            block = fm.mainFile.getBlock(offset: offset, maxRecordsCount: mainFileSize)
            for item in self.block!.records {
                if item == record {
                    return item
                }
            }
            
            while block!.supportingFileOffset() != -1 {
                blockHelper1 = fm.supportingFile.getBlock(offset: UInt64(block!.supportingFileOffset()), maxRecordsCount: supportFileSize)
                for item in blockHelper1!.records {
                    if item == record {
                        return item
                    }
                }
                block = blockHelper1?.copy()
            }
        }
        
        return nil
    }
    
}

// MARK: - Privates

extension DynamicHash {
    
    
}
