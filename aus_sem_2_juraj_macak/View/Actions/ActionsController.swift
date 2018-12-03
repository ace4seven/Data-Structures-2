//
//  ActionsController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

// MARK: - Variables

class ActionsController: UIViewController {
    
    fileprivate var viewModel = ActionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.setup(viewDelegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PropertyDetailController, let property = sender as? Property {
            vc.property = property
        }
    }
    
}

extension ActionsController: ActionsViewDelegate {
    
    func showDetail(property: Property) {
        performSegue(withIdentifier: String(describing: PropertyDetailController.self), sender: property)
    }
    
    
    func showAlert(message: ActionMessage) {
        composeAlert(title: "Pozor", message: message.value, completion: { _ in })
    }
    
}

// MARK: - IBActions

extension ActionsController {
    
    @IBAction func changeDescriptionButtonPressed() {
        changeDescForm()
    }
    
    @IBAction func searchPropertyButtonPressed(_ sender: Any) {
        searchOptionsForm()
    }
    
    @IBAction func addPropertyButtonPressed(_ sender: Any) {
        addPropertyForm()
    }
    
}

// MARK: - Fileprivates

extension ActionsController {
    
    fileprivate func searchOptionsForm() {
        let alertController = UIAlertController(title: "Vyhľadávanie podľa", message: "Vyberte možnosť", preferredStyle: .alert)
        
        let uniqueAction = UIAlertAction(title: "Unikátneho čísla nehnuteľností", style: .default, handler: { alert -> Void in
            self.searchByUniqueID()
        })
        
        let regionNameIdAction = UIAlertAction(title: "Názvu K.Ú. a súpisného čísla", style: .default, handler: { alert -> Void in
            self.searchByRegionAndID()
        })
        
        let cancelAction = UIAlertAction(title: "Zrušiť", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(uniqueAction)
        alertController.addAction(regionNameIdAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func searchByUniqueID() {
        let alertController = UIAlertController(title: "Číslo nehnuteľností", message: "Vyhľadávanie podľa unikatného čísla nehnuteľností", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte unikátne číslo nehnuteľností"
        }
        let searchAction = UIAlertAction(title: "Vyhľadať", style: .default, handler: { alert -> Void in
            let uniqueTextfield = alertController.textFields![0] as UITextField
            self.viewModel.searchByUnique(id: UInt(uniqueTextfield.text ?? "") ?? 0)
        })
        let cancelAction = UIAlertAction(title: "Zrušiť", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func changeDescForm() {
        let alertController = UIAlertController(title: "Číslo nehnuteľností", message: "Zmena popisu nehnuteľností", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte unikátne číslo nehnuteľností"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte nový popis nehnuteľností"
        }
        let searchAction = UIAlertAction(title: "Zmeniť", style: .default, handler: { alert -> Void in
            let uniqueTextfield = alertController.textFields![0] as UITextField
            let descTextField = alertController.textFields![1] as UITextField
            self.viewModel.changeDesc(propertyUnique: UInt(uniqueTextfield.text ?? "") ?? 0, desc: descTextField.text ?? "")
        })
        let cancelAction = UIAlertAction(title: "Zrušiť", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func searchByRegionAndID() {
        let alertController = UIAlertController(title: "Súpisné číslo, názov K.Ú.", message: "Vyhľadávanie podľa názvu K.Ú. a súpisného čísla", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte názov k.ú"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte súpisné číslo nehnuteľností"
        }
        
        let searchAction = UIAlertAction(title: "Vyhľadať", style: .default, handler: { alert -> Void in
            let regionNameTextfield = alertController.textFields![0] as UITextField
            let propertyIDTextField = alertController.textFields![1] as UITextField
            self.viewModel.searchByNameAndId(regionName: regionNameTextfield.text ?? "", propertyID: UInt(propertyIDTextField.text ?? "") ?? 0)
        })
        let cancelAction = UIAlertAction(title: "Zrušiť", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func addPropertyForm() {
        let alertController = UIAlertController(title: "Pridanie nehnuteľnosti", message: "Vypíšte všetky údaje", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte unikátne ID nehnuteľnosti"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte názov k.ú"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte súpisné číslo nehnuteľností"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Zadajte popis nehnuteľnosti"
        }
        
        let searchAction = UIAlertAction(title: "Uložiť", style: .default, handler: { alert -> Void in
            let uniqueIDTextfield = alertController.textFields![0] as UITextField
            let regionNameTextField = alertController.textFields![1] as UITextField
            let propertyIDTextField = alertController.textFields![2] as UITextField
            let descTextField = alertController.textFields![3] as UITextField
            
            guard let uniqueID: UInt = UInt(uniqueIDTextfield.text ?? ""), let regionName = regionNameTextField.text, let propertyID: UInt = UInt(propertyIDTextField.text ?? ""), let desc = descTextField.text else {
                self.composeAlert(title: "Pozor", message: "Nespravne zadané vstupné údaje, skúste znova", completion: {_ in })
                return
            }
            
            self.viewModel.addProperty(property: Property(uniqueID: uniqueID, propertyID: propertyID, regionName: regionName, desc: desc))
        })
        let cancelAction = UIAlertAction(title: "Zrušiť", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
}
