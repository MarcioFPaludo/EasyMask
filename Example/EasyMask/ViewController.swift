//
//  ViewController.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 01/01/2021.
//  Copyright (c) 2021 MarcioFPaludo. All rights reserved.
//

import UIKit
import EasyMask

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var cpfTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {	
        var shouldChangeCharacters: Bool = false
        
        if textField == cpfTextField {
            shouldChangeCharacters = textField.shouldChangeCharacters(in: range, replacementString: string, for: .cpf)
        } else if textField == phoneTextField {
            shouldChangeCharacters = textField.shouldChangeCharacters(in: range, replacementString: string, for: .phone)
        }
        
        return shouldChangeCharacters
    }
}

