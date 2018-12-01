//
//  Trie.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/25/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

class Trie {
    
    public private(set) var root: TrieNode?
    public init() {}
    
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
            
            // NODES are still in nill offset addres, which will configure later.
            
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
