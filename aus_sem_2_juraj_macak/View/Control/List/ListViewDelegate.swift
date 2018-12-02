//
//  ListViewDelegate.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation

enum ListType {
    case property
    case propertyRegionNumber
    case propertyUnique
}

protocol ListVM: class {
    func setup(viewDelegate: ListViewDelegate)
}

protocol ListViewDelegate: class {
    func showItems(items: [ListItemType], for type: ListType)
}
