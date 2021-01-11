//
//  EasyMaskDefaults.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 24/12/20.
//

import Foundation

public extension Mask {
    static var cpf: Mask {
        return .init(format: "ccc.ccc.ccc-cc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isWholeNumber
            case .full(let string): return !string.isEmpty
            }
        }
    }
    
    static var cnpj: Mask {
        return .init(format: "ccc.ccc.ccc/cccc-cc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isWholeNumber
            case .full(let string): return !string.isEmpty
            }
        }
    }
    
    static var phone: Mask {
        return .init(format: "(cc) cccc-ccccc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isWholeNumber
            case .full(let string): return !string.isEmpty
            }
        }
    }
    
    static var time: Mask {
        return .init(format: "cc:cc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isNumber
            case .full(let string): return !string.isEmpty
            }
        }
    }
}
