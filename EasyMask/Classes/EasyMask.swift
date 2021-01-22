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
    fileprivate let validationHandler: ValidationHandler
    fileprivate static let letters = "Cc"
    let isCaseSensitive: Bool
    let format: String
    
    // MARK: Instance
    
    init(format: String, caseSensitive: Bool = false, _ handler: ValidationHandler? = nil) {
        validationHandler = handler ?? {
            switch $0 {
            case .full(let s): return s.count == format.count
            default: return true
            }
        }
        isCaseSensitive = caseSensitive
        self.format = format
    }
    
    // MARK: Validation
    
    fileprivate func performValidation(for string: String) -> Bool {
        return validationHandler(.full(string))
    }
    
    // MARK: Mask Work
    
    fileprivate func addMask(to string: String) -> String {
        var maskedString: String, replaceCharacters = removeMask(from: string)
        
        maskedString = format.enumerated().compactMap({
            var character: String?
            
            while replaceCharacters.count > 0 && character == nil {
                if Mask.letters.contains($0.element) {
                    let replaceCharacter = replaceCharacters.removeFirst()
                    if validationHandler(.character(replaceCharacter, index: $0.offset)) {
                        character = String(replaceCharacter)
                        if let c = character, isCaseSensitive {
                            character = "C" == $0.element ? c.uppercased() : c.lowercased()
                        }
                    }
                } else {
                    character = String($0.element)
                }
            }
            
            return character
        }).joined()
        
        return maskedString
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
    fileprivate func textByReplacingCharacters(in range: NSRange, replacementString string: String) -> String? {
        return (text as NSString?)?.replacingCharacters(in: range, with: string)
    }
    
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, for mask: Mask) -> Bool {
        let newText = textByReplacingCharacters(in: range, replacementString: string)?.applyMask(mask)
        let addedCharacters = string.count > 0 ? (newText?.count ?? 0) - (text?.count ?? 0) : 0
        text = newText
        
        if let newPostion = position(from: beginningOfDocument, offset: range.location + addedCharacters) {
            if let newRange = textRange(from: newPostion, to: newPostion) {
                selectedTextRange = newRange
            }
        }
        
        return false
    }
    
    func unmaskedText(for mask: Mask) -> String? {
        return text?.removeMask(mask)
    }
}

// MARK: - MaskTextField

public class MaskTextField: UITextField, UITextFieldDelegate {
    fileprivate var lengthOfMask: [Int: Mask] = [:]
    fileprivate(set) var unmaskedText: String?
    fileprivate var lengths: [Int] = []
    public var masks: [Mask] {
        get { return Array(lengthOfMask.values) }
        set {
            var lengthOfMask: [Int: Mask] = [:]
            for mask in newValue {
                lengthOfMask[mask.format.compactMap({
                    return Mask.letters.contains($0) ? $0 : nil
                }).count] = mask
            }
            
            delegate = self
            self.lengthOfMask = lengthOfMask
            lengths = Array(lengthOfMask.keys).sorted()
        }
    }
    public var currentMask: Mask? {
        var currentMask: Mask?
        
        if let currentLength = lengths.first(where: { (unmaskedText ?? "").count <= $0 }) {
            currentMask = lengthOfMask[currentLength]
        }
        
        return currentMask
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldChange = true
        
        if let maskTF = textField as? MaskTextField, let maxLength = maskTF.lengths.last {
            var needMaskLenth: Int?
            
            if maskTF.lengthOfMask.count > 1 {
                let newText = maskTF.textByReplacingCharacters(in: range, replacementString: string)
                let newLength = newText?.removeMask(maskTF.currentMask!).count ?? 0
                needMaskLenth = maskTF.lengths.first(where: { return newLength <= $0 })
            }
            
            if let m = maskTF.lengthOfMask[needMaskLenth ?? maxLength] {
                shouldChange = maskTF.shouldChangeCharacters(in: range, replacementString: string, for: m)
                maskTF.unmaskedText = maskTF.unmaskedText(for: m)
            }
        }
        
        return shouldChange
    }
}

