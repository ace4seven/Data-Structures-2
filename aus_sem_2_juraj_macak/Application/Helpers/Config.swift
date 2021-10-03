//
//  Config.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Config {
    
    var mainFileSize: Int?
    var supportFileSize: Int?
    var deep: Int?
    
    var _fileHandle: FileHandle?
    
    static var fileManager = FileManager.default
    static let filePath = C.DOC_PATH + "/" + "config.bin"
    
    init?() {
        if !Config.fileManager.fileExists(atPath: Config.filePath) {
            return nil
        }
        
        _fileHandle = FileHandle(forUpdatingAtPath: Config.filePath)
        
        let length = 8 + 8 + 8
        _fileHandle!.seek(toFileOffset: 0)
        let data: [Byte] = [Byte](_fileHandle!.readData(ofLength: length))
        
        let mainSizeData = data.enumerated().compactMap { $0 < 8 ? $1 : nil }
        let supportSizeData = data.enumerated().compactMap { $0 >= 8 && $0 < 16 ? $1 : nil }
        let deepData = data.enumerated().compactMap { $0 >= 16 ? $1 : nil }

        self.mainFileSize = ByteConverter.fromByteArray(mainSizeData, Int.self)
        self.supportFileSize = ByteConverter.fromByteArray(supportSizeData, Int.self)
        self.deep = ByteConverter.fromByteArray(deepData, Int.self)
    }
    
    static func saveNewConfig(mainFileSize: Int, supportFileSize: Int, deep: Int) {
        var buffer:[Byte] = []
        
        let mainSizeBytes = ByteConverter.toByteArray(mainFileSize)
        let supportFileSizeBytes = ByteConverter.toByteArray(supportFileSize)
        let deepBytes = ByteConverter.toByteArray(deep)
        
        
        buffer.append(contentsOf: mainSizeBytes)
        buffer.append(contentsOf: supportFileSizeBytes)
        buffer.append(contentsOf: deepBytes)
        
        fileManager.createFile(atPath: Config.filePath, contents: nil, attributes: nil)
        let fileHandle = FileHandle(forUpdatingAtPath: Config.filePath)
        
        fileHandle?.write(Data(bytes: buffer))
    }
    
    static func configExists() -> Bool {
        return Config.fileManager.fileExists(atPath: Config.filePath)
    }
    
    func removeFile() {
        do {
            try Config.fileManager.removeItem(atPath: Config.filePath)
        } catch(let error) {
            print("Subor sa nepodarilo odstranin: \(error.localizedDescription)")
        }
        print("Subor vymazany \(Config.filePath)")
    }
    
}
