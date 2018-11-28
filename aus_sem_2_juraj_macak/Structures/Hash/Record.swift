//
//  Record.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol Record: Equatable {
    
    func getHash() -> [Byte]
    func toByteArray() -> [Byte]
    
    static func fromByteArray(_ bytes: [Byte]) -> Any
    static func getSize() -> Int
    
}
