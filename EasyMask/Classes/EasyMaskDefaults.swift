//
//  EasyMaskDefaults.swift
//  EasySoap
//
//  Created by Marcio F. Paludo on 24/12/20.
//

import Foundation

extension Mask {
    static var cpf: Mask {
        return .init(format: "ccc.ccc.ccc-cc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isWholeNumber
            case .full(let string): return true
            }
        }
    }
    
    static var cnpj: Mask {
        return .init(format: "ccc.ccc.ccc/cccc-cc") { (type) -> Bool in
            switch type {
            case .character(let character): return character.isWholeNumber
            case .full(let string): return true
            }
        }
    }
}
