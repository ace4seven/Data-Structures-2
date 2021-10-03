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
    @IBOutlet weak var progressWrapper: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    
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
        
        progressWrapper.alpha = 0.0
        
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
    
    @IBAction func createConfigFile() {
        guard let deep: Int = Int(deepTextField.text ?? ""), let mainSize: Int = Int(self.mainFileSizeTextField.text ?? ""), let supportSize: Int = Int(self.supportFileSizeTextField.text ?? "") else {
            composeAlert(title: "Pozor", message: "Je potrebné vyplniť všetky polia") { _ in }
            return
        }
        CoreHash.shared.changeConfig(mainFileSize: mainSize, supportFileSize: supportSize, deep: deep)
        
        composeAlert(title: "Úsppech", message: "Konfiguračný súbor bol úspešné vytvorený", completion: { _ in })
    }
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        if !Config.configExists() {
            composeAlert(title: "Pozor", message: "Musíte vytvoriť konfiguračný súbor, aby sa mohli dáta generovať !!!", completion: { _ in})
            return
        }
        
        CoreHash.shared.cleanFiles()
        
        progressWrapper.alpha = 1.0
        
        generateButton.isUserInteractionEnabled = false
        generateButton.setTitle("Generujem dáta ...", for: .normal)
        generateButton.alpha = 0.3
        self.view.layoutIfNeeded()
        showIndicator(status: true)
        
        let sliderValue = self.propertySlider.value
        
        DispatchQueue.main.asyncAfter(seconds: 0.5) { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async {
                CoreHash.shared.generateProperties(count: Int(sliderValue), completion:
                    { [weak self] in
                        DispatchQueue.main.sync {
                            self?.showIndicator(status: false)
                            self?.composeAlert(title: "Uspech", message: "Dáta boli úspešne vygenerované", completion: { _ in
                                self?.navigationController?.popViewController(animated: true)
                            })
                        }
                    }, progress: { [weak self] percent in
                        
                        DispatchQueue.main.sync {
                            self?.progressView.setProgress(Float(percent) / 100, animated: true)
                            self?.percentLabel.text = "\(percent) %"
                        }
                })
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        propertiesCountLabel.text = "\(Int(propertySlider.value))"
    }
    
}
