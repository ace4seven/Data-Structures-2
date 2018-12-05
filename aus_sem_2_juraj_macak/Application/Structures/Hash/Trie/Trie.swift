//
//  Trie.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/25/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

struct ExternalNodeRow {
    
    let traversion: [UInt8]
    let indexToFile: UInt64?
    
    func toStringLine() -> String {
        if let index = indexToFile {
            return "\(index)\(C.SEPARATOR)\(arrayToString())\n"
        } else {
            
        }
        return "\("X")\(C.SEPARATOR)\(arrayToString())\n"
    }
    
    private func arrayToString() -> String {
        var result = ""
        
        for num in self.traversion {
            result.append(String(num))
        }
        
        return result
    }
    
}

class Trie {
    
    public private(set) var root: TrieNode?
    public init() {}
    
    init(recovery: [ExternalNodeRow]) {
        if recovery.count == 1 {
            self.root = ExternalNode(offset: recovery[0].indexToFile)
        } else if recovery.count > 1 {
            self.root = InternalNode()
            var node = root
            for item in recovery {
                var addedNodes = 0
                for index in item.traversion {
                    if index == 0 {
                        if let intNode = node as? InternalNode {
                            if intNode.leftChild == nil {
                                if addedNodes == item.traversion.count - 1 {
                                    intNode.leftChild = ExternalNode(offset: item.indexToFile)
                                    node = self.root
                                } else {
                                    intNode.leftChild = InternalNode()
                                    node = intNode.leftChild
                                }
                                
                                intNode.leftChild?.parrent = intNode
                                addedNodes += 1
                            } else {
                                node = intNode.leftChild
                                addedNodes += 1
                            }
                        }
                    } else {
                        if let intNode = node as? InternalNode {
                            if intNode.rightChild == nil {
                                if addedNodes == item.traversion.count - 1 {
                                    intNode.rightChild = ExternalNode(offset: item.indexToFile)
                                    node = self.root
                                } else {
                                    intNode.rightChild = InternalNode()
                                    node = intNode.rightChild
                                }
                                intNode.rightChild?.parrent = intNode
                                addedNodes += 1
                            } else {
                                node = intNode.rightChild
                                addedNodes += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - Public

extension Trie {
    
    func addExternalRoot(offset: UInt64) {
        self.root = ExternalNode(offset: offset)
    }
    
    func find(bitset: [Byte]) -> ExternalNode {
        var tempNode = root!
        var bitIndex = 0
        while (tempNode as? ExternalNode) == nil && bitIndex <= bitset.count {
            let node = tempNode as! InternalNode
            tempNode = bitset[bitIndex] == 0 ? node.leftChild! : node.rightChild!
            bitIndex += 1
        }
        
        let findedNode = tempNode as! ExternalNode
        return findedNode
    }
    
    func increaseTreeNodes(ex1: ExternalNode, ex2: ExternalNode, extCurrent: ExternalNode) {
        
        if let parrent = extCurrent.parrent as? InternalNode {
            
            let internalNode = InternalNode()
    
            ex1.parrent = internalNode
            ex2.parrent = internalNode
            
            if let leftExtNode = parrent.leftChild as? ExternalNode, leftExtNode.offset == extCurrent.offset {
                parrent.leftChild = internalNode
                internalNode.parrent = parrent
            } else {
                parrent.rightChild = internalNode
                internalNode.parrent = parrent
            }
            
            internalNode.leftChild = ex1
            internalNode.rightChild = ex2
        } else {
            self.root = InternalNode()
            if let node = self.root as? InternalNode {
                node.leftChild = ex1
                node.rightChild = ex2
                ex1.parrent = self.root
                ex2.parrent = self.root
            }
        }
    }

    
}

extension Trie {
    
    func prepareToExport() -> [ExternalNodeRow] {
        var result = [ExternalNodeRow]()
        traverseInOrder(node: self.root, path: []) { row in
            result.append(row)
        }
        
        return result
    }
    
    private func traverseInOrder(node: TrieNode?, path: [UInt8], completion: @escaping ((ExternalNodeRow) -> ())) {
        var newPath = path
        if let node = node as? InternalNode {
            newPath.append(0)
            traverseInOrder(node: node.leftChild, path: newPath, completion: completion)
        }
        
        if node as? InternalNode != nil {
            _ = newPath.popLast()
        }
        
        if let node = node as? ExternalNode {
            completion(ExternalNodeRow(traversion: newPath, indexToFile: node.offset))
        }
        
        if let node = node as? InternalNode {
            newPath.append(1)
            traverseInOrder(node: node.rightChild, path: newPath, completion: completion)
        }
    }
    
}
