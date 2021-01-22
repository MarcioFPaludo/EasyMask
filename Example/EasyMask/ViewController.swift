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

class MaskTextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: MaskTextField!
}

class ViewController: UITableViewController, UITextFieldDelegate {
    
    enum Section: CaseIterable {
        case UITextField, MaskTextField
        
        var identifier: String {
            return String(describing: self)
        }
        var title: String {
            switch self {
            case .MaskTextField: return "Mask Text Field Section"
            case .UITextField: return "UI Text Field Section"
            }
        }
    }
    var masks: [String: Mask] = [
        "CNPJ": .cnpj,
        "CPF": .cpf,
        "SSN": .ssn
    ]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .UITextField: return masks.count
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section], cell = tableView.dequeueReusableCell(withIdentifier: section.identifier, for: indexPath)
        
        if let tfCell = cell as? TextFieldCell {
            tfCell.textField.placeholder = masks.enumerated().first(where: {
                return $0.offset == indexPath.row
            })?.element.key
        } else if let mtfCell = cell as? MaskTextFieldCell {
            mtfCell.textField.placeholder = "CPF/CNPJ"
            mtfCell.textField.masks = [ .cpf, .cnpj ]
        }
        
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

