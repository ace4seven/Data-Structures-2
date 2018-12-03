//
//  SettingsController.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 12/2/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit
import Foundation
import GoodSwift

// MARK: - Variables

class SettingsController: UITableViewController {
    
    @IBOutlet weak var deepTextField: UITextField!
    @IBOutlet weak var mainFileSizeTextField: UITextField!
    @IBOutlet weak var supportFileSizeTextField: UITextField!
    @IBOutlet weak var propertiesCountLabel: UILabel!
    @IBOutlet weak var propertySlider: UISlider!
    @IBOutlet weak var buttonIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonWrapper: UIView!
    @IBOutlet weak var generateButton: UIButton!
    
}

// MARK: - LifeCycle

extension SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.contentInset.top = 20
        
        hideKeyboardWhenTappedAround()
        
        title = "Nastavenie"
        
        self.buttonIndicator.alpha = 0.0
        self.buttonIndicator.stopAnimating()
    }
    
    fileprivate func showIndicator(status: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.buttonIndicator.alpha = status ? 1.0 : 0.0
            if status {
                self?.buttonIndicator.startAnimating()
            } else {
                self?.buttonIndicator.stopAnimating()
            }
            self?.buttonWrapper.layoutIfNeeded()
        }
    }
    
}

// MARK: - IBActions

extension SettingsController {
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        guard let deep: Int = Int(deepTextField.text ?? ""), let mainSize: Int = Int(self.mainFileSizeTextField.text ?? ""), let supportSize: Int = Int(self.supportFileSizeTextField.text ?? "") else {
            composeAlert(title: "Pozor", message: "Je potrebné vyplniť všetky polia") { _ in }
            
            return
        }
        
        CoreHash.shared.cleanFiles()
        CoreHash.shared.changeConfig(mainFileSize: mainSize, supportFileSize: supportSize, deep: deep)
        
        generateButton.isUserInteractionEnabled = false
        generateButton.setTitle("Generujem dáta ...", for: .normal)
        generateButton.alpha = 0.3
        self.view.layoutIfNeeded()
        showIndicator(status: true)
        
        DispatchQueue.main.asyncAfter(seconds: 0.6) { [weak self] in
            CoreHash.shared.generateProperties(count: Int(self?.propertySlider.value ?? 100)) { [weak self] in
                self?.showIndicator(status: false)
                self?.composeAlert(title: "Uspech", message: "Dáta boli úspešne vygenerované", completion: { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        propertiesCountLabel.text = "\(Int(propertySlider.value))"
    }
    
}
