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
    var parrent: TrieNode? { get set }
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
    
    fileprivate var _offset: UInt64?
    
    var indicator: Indicator
    var parrent: TrieNode?
    
    var offset: UInt64? {
        get {
            return self._offset
        }
        set(value) {
            self._offset = value
        }
    }
    
    init() {
        self.indicator      = Indicator.External
    }
    
    init(offset: UInt64?) {
        self.indicator      = Indicator.External
        self._offset = offset
    }
    
    func getDeep() -> Int {
        var index = 0
        var temp: TrieNode? = self
        
        while temp?.parrent != nil {
            temp = temp?.parrent
            index += 1
        }
        
        return index
    }
    
}
