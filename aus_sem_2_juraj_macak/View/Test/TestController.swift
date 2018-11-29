//
//  ViewController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/10/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
//        test()
//        testBinaryFile()
//        testBlock()
//        testBitset()
        
        testDynamicHash()
    }
    
}

extension TestController {
    
    func testDynamicHash() {
        let dynamicHash = DynamicHash(deep: 10, mainFileSize: 4, supportFileSize: 2, fileManager: UnFileManager<TestModel>(mainFileName: "mainFile", supportingFileName: "supportFile"))
        
        
        for i in 1..<100000 {
            if !dynamicHash.insert(TestModel(id: i, desc: "aaaaaaaaaaaaaaaa")) {
                print("Nemohol som vlozit")
            }
        }
        
        
        for i in 1..<100000 {
            if (dynamicHash.find(TestModel(id: i, desc: "aaaaaaaaaaaaaaaa")) == nil) {
                print("Nenaslo: \(i)")
            }
        }
        
        print("Hotovo")
        
    }
    
//    func testBitset() {
//        let numb = 10
//        let numb2 = 10
//
//        var test = "lorem ipsum"
//        var test2 = "lorem ipsum"
//
//
//
//    }
//
//    func test() {
//        let str = "Lorem ipsum dolor"
//        var buf = ByteConverter.toByteArray(str)
//
//        print(buf)
//
//        let numb: UInt32 = 13
//
//        let intBuf = ByteConverter.toByteArray(numb)
//
//        buf.append(contentsOf: intBuf)
//
//        print(buf)
//
//        print(str.count)
//
//        let number = buf.enumerated().compactMap { $0 >= 16 ? $1 : nil }
//
//        print(ByteConverter.fromByteArray(buf, String.self))
//        print(ByteConverter.fromByteArray(number, Int.self))
//    }
    
    func testBinaryFile() {
//        let tet1File = TestModel(id: 11, desc: "aaaaaaaaaaaaaaaa")
//        let tet2File = TestModel(id: 14, desc: "bbbbbbbbbbbbbbbb")
//
//        UnorderedFile.shared.fileHandle.seekToEndOfFile()
//        UnorderedFile.shared.fileHandle.write(Data(bytes: tet1File.toByteArray()))
//        UnorderedFile.shared.fileHandle.seekToEndOfFile()
//        UnorderedFile.shared.fileHandle.write(Data(bytes: tet2File.toByteArray()))

//        UnorderedFile.shared.fileHandle.seek(toFileOffset: 0)
//        let data: [Byte] = [Byte](UnorderedFile.shared.fileHandle.readData(ofLength: 20))
//        let test = TestModel(data: data)
//
//        UnorderedFile.shared.fileHandle.seek(toFileOffset: 40)
//        let data2: [Byte] = [Byte](UnorderedFile.shared.fileHandle.readData(ofLength: 20))
//        let test2 = TestModel(data: data2)
//
//        print(test.id)
//        print(test.desc)
//
//        print(test2.id)
//        print(test2.desc)
    }
    
    func testBlock() {
//        let block1 = Block<TestModel>()
//
//        block1.insert(record: TestModel(id: 33, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 34, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 35, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 36, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//        block1.insert(record: TestModel(id: 37, desc: "aaaaaaaaaaaaaaaa"))
//
//        UnorderedFile.shared.insert(block: block1, address: 0)
//
//        let block2 = Block<TestModel>()
//
//        block2.insert(record: TestModel(id: 33, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 34, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 35, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 36, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))
//        block2.insert(record: TestModel(id: 37, desc: "bbbbbbbbbbbbbbbb"))

//        UnorderedFile.shared.insert(block: block2, address: UInt64(Block<TestModel>.getSize()))
        
//        let block = UnorderedFile.shared.getBlock(address: 0, length: C.BLOCK_SIZE * TestModel.getSize())
//
//        for record in block.records {
//            print("Prvy block parametre")
//            print(record.id)
//            print(record.desc)
//        }
//
//        let block2 = UnorderedFile.shared.getBlock(address: 80, length: C.BLOCK_SIZE * TestModel.getSize())
//
//        for record in block2.records {
//            print("Druhy block parametre")
//            print(record.id)
//            print(record.desc)
//        }
        
    }
    
}

