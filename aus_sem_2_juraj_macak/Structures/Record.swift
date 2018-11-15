//
//  Record.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/15/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

// MARK: - Protocol

public protocol Record: class {
    func getHash()
    func toByteArray()
    func fromByteArray()
    func getSize()
}
