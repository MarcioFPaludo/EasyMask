//
//  EasyMask.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 24/12/20.
//

import UIKit

// MARK: - Mask Struct

public struct Mask {
    enum ValidationType { case character(Character), full(String) }
    fileprivate static let letters:[Character] = ["C", "c"]
    typealias ValidationHandler = (ValidationType) -> Bool
    fileprivate let validationHandler: ValidationHandler?
    let isCaseSensitive: Bool
    let format: String
    
    // MARK: Instance
    
    init(format: String, caseSensitive: Bool = false, _ handler: ValidationHandler? = nil) {
        isCaseSensitive = caseSensitive
        validationHandler = handler
        self.format = format
    }
    
    // MARK: Validation
    
    fileprivate func performValidation(for string: String) -> Bool {
        return validationHandler?(.full(string)) ?? true
    }
    
    // MARK: Mask Work
    
    fileprivate func addMask(to string: String) -> String {
        var replaceCharacters = removeMask(from: string)
        
        if let handler = validationHandler {
            replaceCharacters = String(replaceCharacters.compactMap({ return handler(.character($0)) ? $0 : nil }))
        }
        
        return format.compactMap({
            var character: String?
            
            if replaceCharacters.count > 0 {
                if Mask.letters.contains($0) {
                    character = String(replaceCharacters.removeFirst())
                    
                    if isCaseSensitive {
                        character = "C" == $0 ? character?.uppercased() : character?.lowercased()
                    }
                } else {
                    character = String($0)
                }
            }
            
            return character
        }).joined()
    }
    
    fileprivate func removeMask(from string: String) -> String {
        let characters = format.compactMap({ return !Mask.letters.contains($0) ? $0 : nil })
        return String(string.compactMap({ return !characters.contains($0) ? $0 : nil }))
    }
    
}

// MARK: - String Extension

extension String {
    func applyMask(_ mask: Mask) -> String {
        return mask.addMask(to: self)
    }
    
    func isValid(for mask: Mask) -> Bool {
        return mask.performValidation(for: self)
    }
    
    func removeMask(_ mask: Mask) -> String {
        return mask.removeMask(from: self)
    }
}

// MARK: - TextField Extension

extension UITextField: UITextFieldDelegate {
    public func shouldChangeCharacters(in range: NSRange, replacementString string: String, for mask: Mask) -> Bool {
        let newText = (text as NSString?)?.replacingCharacters(in: range, with: string).applyMask(mask)
        let addedCharacters = string.count > 0 ? (newText?.count ?? 0) - (text?.count ?? 0) : 0
        text = newText
        
        if let newPostion = position(from: beginningOfDocument, offset: range.location + addedCharacters) {
            if let newRange = textRange(from: newPostion, to: newPostion) {
                selectedTextRange = newRange
            }
        }
        
        return false
    }
}
