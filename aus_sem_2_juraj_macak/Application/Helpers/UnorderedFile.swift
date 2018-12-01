//
//  UnorderedFile.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/23/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

typealias File = UnorderedFile

class UnFileManager<T: Record> {
    
    var mainFile: UnorderedFile<T>
    var supportingFile: UnorderedFile<T>
    
    init(mainFileName: String, supportingFileName: String) {
        self.mainFile = UnorderedFile(fileName: mainFileName)
        self.supportingFile = UnorderedFile(fileName: supportingFileName)
    }
    
}

class UnorderedFile<T: Record> {
    
    fileprivate var fileManager = FileManager.default
    fileprivate var _fileHandle: FileHandle?
    
    var fileHandle: FileHandle {
        get {
            return self._fileHandle!
        }
    }
    
    init(fileName: String) {
        let filePath = C.DOC_PATH + "/" + fileName + ".bin"
        
        print(filePath)
        
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        _fileHandle = FileHandle(forUpdatingAtPath: filePath)
    }
    
}

// MARK: - Public

extension UnorderedFile {
    
    func insert(block: Block<T>, address: UInt64) {
        fileHandle.seek(toFileOffset: address)
        fileHandle.write(Data(bytes: block.toByteArray()))
    }
    
    func getBlock(offset: UInt64, maxRecordsCount: Int) -> Block<T> {
        let length = Int(maxRecordsCount * T.getSize() + 9)
        fileHandle.seek(toFileOffset: offset * UInt64(length))
        let data: [Byte] = [Byte](fileHandle.readData(ofLength: length))
        return Block(bytes: data, maxRecordsCount: maxRecordsCount, offset: offset)
    }
    
}
