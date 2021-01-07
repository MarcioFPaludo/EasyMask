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

    @IBOutlet weak var cpfTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {	
        return cpfTextField.shouldChangeCharacters(in: range, replacementString: string, for: .cpf)
    }
}

