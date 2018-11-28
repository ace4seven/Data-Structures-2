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
    
    func addExternalRoot() {
        self.root = ExternalNode(blockAddress: 0)
    }
    
    func find(bitset: [Byte]) -> ExternalNode {
        var tempNode = root!
        var bitIndex = 0
        while (tempNode as? ExternalNode) == nil && bitIndex <= bitset.count {
            let node = tempNode as! InternalNode
            tempNode = bitset[bitIndex] == 0 ? node.leftChild! : node.rightChild!
            bitIndex += 1
        }
        
        return tempNode as! ExternalNode
    }
    
}

// MARK: - Debug

extension Trie: CustomStringConvertible {
    
    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}
