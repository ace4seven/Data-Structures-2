//
//  Stack.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/4/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

public struct Stack<Element> {
    private var storage: [Element] = []
    public init() { }
    
    var data: [Element] {
        get {
            return self.storage
        }
    }
    
    var count: Int {
        get {
            return storage.count
        }
    }
}

// MARK: - Operations

extension Stack {
    
    public mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> Element? {
        return storage.popLast()
    }
    
    public func peek() -> Element? {
        return storage.last
    }
    
    public var isEmpty: Bool {
        return peek() == nil
    }
    
}

extension Stack: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
    
}

extension Stack: CustomStringConvertible {
    
    public var description: String {
        let topDivider = "----top----\n"
        let bottomDivider = "\n-----------"
        let stackElements = storage
            .map { "\($0)" }
            .reversed()
            .joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
    
}
