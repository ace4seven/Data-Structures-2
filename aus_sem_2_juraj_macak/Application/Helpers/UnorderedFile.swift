//
//  UnorderedFile.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/23/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class UnorderedFile {
    
    public static let shared = UnorderedFile()
    
    fileprivate var fileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    
    var fileHandle: FileHandle {
        get {
            return self._fileHandle!
        }
    }
    
    private init() {
        let filePath = C.DOC_PATH + "/" + C.FILE_NAME + ".bin"
        
        print(filePath)
        
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        _fileHandle = FileHandle(forUpdatingAtPath: filePath)
    }
    
}

// MARK: - Public

extension UnorderedFile {
    
    func insert(block: Block<TestModel>, address: UInt64) {
        fileHandle.seek(toFileOffset: address)
        fileHandle.write(Data(bytes: block.toByteArray()))
    }
    
    func getBlock(address: UInt64, length: Int) -> Block<TestModel> {
        fileHandle.seek(toFileOffset: address)
        let data: [Byte] = [Byte](fileHandle.readData(ofLength: length))
        return Block(bytes: data)
    }
    
}

// MARK: - Fileprivates

extension UnorderedFile {
    
//    fileprivate func createNewFile(filePath: String) {
//
//    }
    
}
