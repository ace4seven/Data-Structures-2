//
//  Extensions.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/19/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import Foundation
import UIKit

typealias Byte = UInt8


extension Int {
    
    var bitSet: [Byte] {
        var result = [UInt8]()
        
        var input  = abs(self)
        while(input > 0) {
            result.append(UInt8(input % 2))
            input = input / 2
        }
        if result.count < 8 {
            for _ in result.count..<8 {
                result.append(0)
            }
        }
        
        return result
    }
    
    var staticHash: Int {
        var hash = Int (5381)
        let buf = [UInt8](String(self).utf8)
        
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + Int(b)
        }
        
        return abs(hash)
    }
    
}

extension UInt {
    
    var staticHash: UInt {
        var hash = UInt (5381)
        let buf = [UInt8](String(self).utf8)
        
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + UInt(b)
        }
        
        return hash
    }
    
    var bitSet: [Byte] {
        var result = [UInt8]()
        
        var input  = self
        while(input > 0) {
            result.append(UInt8(input % 2))
            input = input / 2
        }
        if result.count < 8 {
            for _ in result.count..<8 {
                result.append(0)
            }
        }
        
        return result
    }
    
}

extension String {
    
    func stringToArray() -> [UInt8] {
        var result: [UInt8] = []
        
        for char in self {
            result.append(UInt8(String(char))!)
        }
        
        return result
    }
    
    var staticHash: Int {
        var hash = Int (5381)
        let buf = [UInt8](self.utf8)
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + Int(b)
        }
        
        return abs(hash)
    }
    
    func modifyTo(size: Int, delimeter: Character) -> String {
        var result = ""
        for i in 0..<size {
            if self[i] != "" {
                result.append(self[i])
            } else {
                result.append(delimeter)
            }
        }
        return result
    }
    
    func cleanDelimeter(delimeter: Character) -> String {
        var result = ""
        for char in self {
            if char != delimeter {
                result.append(char)
            }
        }
        
        return result
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}

extension UIViewController {
    
    func composeAlert(title: String, message: String, completion: @escaping ((UIAlertAction) -> ())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
