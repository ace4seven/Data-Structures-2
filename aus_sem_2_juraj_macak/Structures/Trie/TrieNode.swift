//
//  TrieNode.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/25/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

protocol TrieNode: class {
    var parrent: TrieNode? { get }
    var indicator: UInt8 { get }
}

public class InternalNode: TrieNode {
    
    var indicator: UInt8
    
    var parrent: TrieNode?
    var leftChild: TrieNode?
    var rightChild: TrieNode?
    
    var blockAddress: UInt64
    var recordsCount: Int
    
    init(indicator: UInt8, blockAddress: UInt64, recordsCount: Int) {
        self.indicator    = indicator
        self.blockAddress = blockAddress
        self.recordsCount = recordsCount
    }
    
}

public class ExternalNode: TrieNode {
    
    var indicator: UInt8
    var parrent: TrieNode?
    
    init(indicator: UInt8) {
        self.indicator = indicator
    }
    
}

public class BinaryNode<Element> {
    
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    public init(value: Element) {
        self.value = value
    }
}

// MARK: - Traversion

extension BinaryNode {
    
    public func traverseInOrder(visit: (Element) -> Void) {
        leftChild?.traverseInOrder(visit: visit)
        visit(value)
        rightChild?.traverseInOrder(visit: visit)
    }
    
    public func traversePreOrder(visit: (Element) -> Void) {
        visit(value)
        leftChild?.traversePreOrder(visit: visit)
        rightChild?.traversePreOrder(visit: visit)
    }
    
    public func traversePostOrder(visit: (Element) -> Void) {
        leftChild?.traversePostOrder(visit: visit)
        rightChild?.traversePostOrder(visit: visit)
        visit(value)
    }
    
}

// MARK: - TEST TREE

extension BinaryNode: CustomStringConvertible {
    
    public var description: String {
        return diagram(for: self)
    }
    
    private func diagram(for node: BinaryNode?,
                         _ top: String = "",
                         _ root: String = "",
                         _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        return diagram(for: node.rightChild, top + " ", top + "┌──", top + "│ ")
            + root + "\(node.value)\n"
            + diagram(for: node.leftChild, bottom + "│ ", bottom + "└──", bottom + " ")
    }
    
}
