//
//  TrieNode.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/25/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

enum Indicator {
    case Internal
    case External
}

protocol TrieNode: class {
    var parrent: TrieNode? { get }
    var indicator: Indicator { get }
}

public class InternalNode: TrieNode {
    
    var indicator: Indicator
    
    var parrent: TrieNode?
    var leftChild: TrieNode?
    var rightChild: TrieNode?
    
    init() {
        self.indicator = Indicator.Internal
    }
    
}

public class ExternalNode: TrieNode {
    
    var indicator: Indicator
    var parrent: TrieNode?
    
    var blockAddress: UInt64
    var recordsCount: Int
    
    init(blockAddress: UInt64) {
        self.indicator      = Indicator.External
        self.recordsCount   = 0
        
        self.blockAddress = blockAddress
    }
    
}
