//
//  ControlOptionsController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

class ControlOptionsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListController, let type = sender as? ListType {
            let viewModel = ListViewModel(type: type)
            vc.viewModel = viewModel
        }
    }
    
    @IBAction func controlUnOrderedPropertiesPressed(_ sender: Any) {
        performSegue(withIdentifier: String(describing: ListController.self), sender: ListType.property)
    }
    
}
