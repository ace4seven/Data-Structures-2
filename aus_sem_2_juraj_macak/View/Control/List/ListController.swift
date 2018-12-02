//
//  ListController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

enum ListItemType {
    
    case block(address: String)
    case property(property: Property)
    case propertyNameNumber(PropertyByRegionAndNumber)
    case propertyUnique(PropertyByUnique)
    
}

// MARK: - Variables

class ListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var items: [ListItemType] = []
    
    var viewModel: ListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel?.setup(viewDelegate: self)
    }
    
}

// MARK: - ListViewDelegate

extension ListController: ListViewDelegate {
    
    func showItems(items: [ListItemType], for type: ListType) {
        switch type {
        case .property:
            title = "Nehnuteľností v neutriedenom súbore"
        case .propertyRegionNumber:
            title = "Blokovacie indexi - Názov k.u a súpisné číslo"
        case .propertyUnique:
            title = "Blokovacie indexi - Unikátne číslo"
        }
        self.items = items

        tableView.reloadData()
    }
    
}

// MARK: - Fileprivates

extension ListController {
    
}

// MARK: - TableView DataSource and Delegate

extension ListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .block:
            return 58
        case .property:
            return 116
        case .propertyUnique:
            return 65
        case .propertyNameNumber:
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.row] {
        case .block:
            return 58
        case .property:
            return 116
        case .propertyUnique:
            return 65
        case .propertyNameNumber:
            return 90
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.row] {
        case .block(let address):
            if let cell = tableView.dequeueReusableCell(fromClass: BlockCell.self, for: indexPath) {
                cell.setupCell(address: address)
                return cell
            }
        case .property(let property):
            if let cell = tableView.dequeueReusableCell(fromClass: PropertyCell.self, for: indexPath) {
                cell.setupCell(property: property)
                return cell
            }
            
        case .propertyNameNumber(let prop):
            if let cell = tableView.dequeueReusableCell(fromClass: PropertyRegionNumberCell.self, for: indexPath) {
                cell.setupCell(property: prop)
                return cell
            }
        case .propertyUnique(let prop):
            if let cell = tableView.dequeueReusableCell(fromClass: PropertyUniqueCell.self, for: indexPath) {
                cell.setupCell(property: prop)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}
