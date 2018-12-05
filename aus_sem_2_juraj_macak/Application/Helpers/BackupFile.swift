//
//  BackupFile.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/4/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

enum MigrationHeaderType {
    case header(Int)
    case uniqueHash(UInt64, Int64)
    case rowNameIDHash(UInt64, Int64)
    
    var header: String {
        switch self {
        case .header(let freeIndex):
            return "HEADER\(C.SEPARATOR)\(freeIndex)\n"
        case .uniqueHash(let freeMain, let freeSupport):
            return "UNIQUE\(C.SEPARATOR)\(freeMain)\(C.SEPARATOR)\(freeSupport)\n"
        case .rowNameIDHash(let freeMain, let freeSupport):
            return "REGION\(C.SEPARATOR)\(freeMain)\(C.SEPARATOR)\(freeSupport)\n"
        }
    }
    
}

final class BackupFile {
    
    
    fileprivate var fileManager = FileManager.default
    fileprivate var fileHandle: FileHandle?
    fileprivate var scanner: Scanner?
    fileprivate var path: String
    
    init(fileName: String) {
        self.path = C.DOC_PATH + "/" + fileName + ".csv"
        print(self.path)
    }
    
}

// MARK: - Publics

extension BackupFile {
    
    func exportToFile(freeUnorderedFileIndex: Int, uniqueHash: DynamicHashExport, regionNameIDHash: DynamicHashExport) -> Bool {
        do {
            try fileManager.removeItem(atPath: self.path)
        } catch let error {
            debugPrint("\(error)")
        }
        
        fileManager.createFile(atPath: self.path, contents: nil, attributes: nil)
        fileHandle = FileHandle(forUpdatingAtPath: self.path)
        fileHandle?.seekToEndOfFile()
        
        let mainHeader = MigrationHeaderType.header(freeUnorderedFileIndex)
        fileHandle?.write(mainHeader.header.data(using: String.Encoding.utf8)!)
        
        let uniqueHeader = MigrationHeaderType.uniqueHash(uniqueHash.freeOffset, uniqueHash.freeSupportOffset)
        fileHandle?.write(uniqueHeader.header.data(using: String.Encoding.utf8)!)
        
        for item in uniqueHash.trieData {
            fileHandle?.write(item.toStringLine().data(using: String.Encoding.utf8)!)
        }
        
        let regionHeader = MigrationHeaderType.rowNameIDHash(regionNameIDHash.freeOffset, regionNameIDHash.freeSupportOffset)
        fileHandle?.write(regionHeader.header.data(using: String.Encoding.utf8)!)
        
        for item in regionNameIDHash.trieData {
            fileHandle?.write(item.toStringLine().data(using: String.Encoding.utf8)!)
        }
        
        return true
    }
    
    func importFromFile() -> (freeUnorderedFileIndex: Int, uniqueHash: DynamicHashExport, regionNameIDHash: DynamicHashExport) {
        let csvFile = try! String(contentsOfFile: self.path, encoding: String.Encoding.utf8)
        self.scanner = Scanner(string: csvFile)
        
        var freeIndex: Int?
        var uniqueHash: DynamicHashExport?
        var regionHash: DynamicHashExport?
        
        
        var line: NSString?
        var isUniqueScan = false
        var isRegionScan = false
        
        while scanner!.scanUpTo("\n", into: &line) {
            let component = line?.components(separatedBy: C.SEPARATOR)
            
            if let c = component {
                if c[0] == "HEADER" {
                    freeIndex = Int(c[1])
                }
                
                if c[0] == "UNIQUE" {
                    uniqueHash = DynamicHashExport(freeOffset: UInt64(c[1])!, freeSupportOffset: Int64(c[2])!, trieData: [])
                    isRegionScan = false
                    isUniqueScan = true
                    continue
                }
                
                if c[0] == "REGION" {
                    regionHash = DynamicHashExport(freeOffset: UInt64(c[1])!, freeSupportOffset: Int64(c[2])!, trieData: [])
                    isRegionScan = true
                    isUniqueScan = false
                    continue
                }
                
                if isUniqueScan {
                    if c[0] != "X" {
                        uniqueHash?.trieData.append(
                            ExternalNodeRow(traversion: (c[1].stringToArray()),
                                                         indexToFile: UInt64(c[0])))
                    } else {
                        uniqueHash?.trieData.append(ExternalNodeRow(traversion: (c[1].stringToArray()), indexToFile: nil))
                    }
                }
                
                if isRegionScan {
                    if c[0] != "X" {
                        regionHash?.trieData.append(
                            ExternalNodeRow(traversion: (c[1].stringToArray()),
                                            indexToFile: UInt64(c[0])))
                    } else {
                        regionHash?.trieData.append(ExternalNodeRow(traversion: (c[1].stringToArray()), indexToFile: nil))
                    }
                }
            }
            
        }
        
        return (freeIndex!, uniqueHash!, regionHash!)
    }
    
}
