//
//  EasyMask.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 24/12/20.
//

import UIKit

// MARK: - Mask Struct

public struct Mask {
    enum ValidationType { case character(Character, index: Int), full(String) }
    typealias ValidationHandler = (ValidationType) -> Bool
    fileprivate static let letters:[Character] = ["C", "c"]
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
        return format.enumerated().compactMap({
            var character: String?
            
            while replaceCharacters.count > 0 && character == nil {
                if Mask.letters.contains($0.element) {
                    let replaceCharacter = replaceCharacters.removeFirst()
                    
                    if let handler = validationHandler {
                        if handler(.character(replaceCharacter, index: $0.offset)) {
                            character = String(replaceCharacter)
                        }
                    } else {
                        character = String(replaceCharacter)
                    }
                    
                    if let c = character, isCaseSensitive {
                        character = "C" == $0.element ? c.uppercased() : c.lowercased()
                    }
                } else {
                    character = String($0.element)
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

public extension String {
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

public extension UITextField {
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, for mask: Mask) -> Bool {
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
