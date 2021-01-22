//
//  ViewController.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 01/01/2021.
//  Copyright (c) 2021 MarcioFPaludo. All rights reserved.
//

import UIKit
import EasyMask

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
}

class ViewController: UITableViewController, UITextFieldDelegate {
    
    var masks: [String: Mask] = [
        "CNPJ": .cnpj,
        "CPF": .cpf,
        "SSN": .ssn
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        cell.textField.placeholder = masks.enumerated().first(where: { return $0.offset == indexPath.row })?.element.key
        return cell
    }
    
    func rightView(with color: UIColor) -> UIView {
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 30, height: 30)))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = color
        view.clipsToBounds = true
        return view
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var mask = masks[textField.placeholder!], shouldChangeCharacters: Bool = true
        
        if let m = mask {
            shouldChangeCharacters = textField.shouldChangeCharacters(in: range, replacementString: string, for: m)
            textField.rightView = rightView(with: (textField.text ?? "").isValid(for: m) ? .systemGreen : .systemRed)
            textField.rightViewMode = .always
        }
        
        return shouldChangeCharacters
    }
    
}

