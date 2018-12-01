//
//  ViewController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/10/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

enum DuplicityChance {
    case none
    case weak
    case middle
    case strong
    
    var value: Int {
        switch self {
        case .none:
            return 0
        case .weak:
            return 1
        case .middle:
            return 20
        case .strong:
            return 40
        }
    }
}

class TestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicTest(numbOfRecords: 1000, deep: 5, mainFileSize: 3, supportFileSize: 2, duplicityChance: .middle)
        
    }
    
}

extension TestController {
    
    func dynamicTest(numbOfRecords: Int, deep: Int, mainFileSize: Int, supportFileSize: Int, duplicityChance: DuplicityChance) {
         let dynamicHash = DynamicHash(deep: deep, mainFileSize: mainFileSize, supportFileSize: supportFileSize, fileManager: UnFileManager<TestModel>(mainFileName: "main", supportingFileName: "support"))
        
        var addedIndexes = [Int]()
        var addedIntoFile = 0
        
        print()
        print("------------------------------------")
        print()
        print("ℹ️ PRIDAVANIE ZAZNAMOV ... ℹ️")
        print()
        print("------------------------------------")
        print()
        
        for _ in stride(from: 1, to: numbOfRecords + 1, by: 1) {
            var index = Int.random(in: 1...1000000)
            
            while !dynamicHash.insert(TestModel(id: index, desc: "aaaaaaaaaaaaaaaa")) {
                index = Int.random(in: 1...1000000)
            }
            
            addedIntoFile += 1
            addedIndexes.append(index)
            
            if Int.random(in: 0...100) < duplicityChance.value && addedIndexes.count > 0 {
                if !dynamicHash.insert(TestModel(id: addedIndexes[Int.random(in: 0..<addedIndexes.count)], desc: "aaaaaaaaaaaaaaaa")) {
                    print("⚠️  \(index) - DUPLICITY not added")
                } else {
                    addedIntoFile += 1
                    print("☠️ Bola pridana duplicita")
                    return
                }
            }
        }
        
        print()
        print("------------------------------------")
        print()
        print("ℹ️ KONTROLA ZAZNAMOV ... ℹ️")
        print()
        print("------------------------------------")
        print()
        
        for index in addedIndexes {
            let record = dynamicHash.find(TestModel(id: index, desc: "aaaaaaaaaaaaaaaa"))
            if record == nil {
                print("☠️ \(index) sa nepodarilo najst")
                return
            } else {
                print("✅ Záznam s kľúčom: \(record!.id) sa nasiel")
            }
        }
        
        print()
        print("----------------------------------------------------")
        print()
        print("Pridanych indexov: \(addedIndexes.count)")
        print("Pridanych zaznamov: \(addedIntoFile)")
        
        print()
        
        var keysFromFile = [Int]()
        print("----------------------------------------------------")
        dynamicHash.traverseMainFile() { block in
            print("👌 HLAVNY BLOK na indexe: \(block.getOffset()!)")
            for item in block.records {
                print("     Záznam s klucom: \(item.id)")
                keysFromFile.append(item.id)
            }
            print("----------------------------------------------------")
        }
        
        print()
        
        print("----------------------------------------------------")
        dynamicHash.traverseSupportFile() { block in
            print("😅 PODPORNY BLOK na indexe: \(block.getOffset()!)")
            for item in block.records {
                print("     Záznam s klucom: \(item.id)")
                keysFromFile.append(item.id)
            }
            print("----------------------------------------------------")
        }
        
        print()
    
        print("----------------------------------------------------")
        print()
        if addedIndexes.count != addedIntoFile {
            print("⚠️ CHYBA, boli pridane duplicity suborov")
        } else {
            if keysFromFile.count == addedIndexes.count {
                print("✅ Testy v poriadku")
            } else {
                print("☠️ TESTY chybne")
            }
        }
        print()
        print("----------------------------------------------------")
        
        
    }
    
}

