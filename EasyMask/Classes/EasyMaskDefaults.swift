//
//  EasyMaskDefaults.swift
//  EasyMask
//
//  Created by Marcio F. Paludo on 24/12/20.
//

import Foundation

public extension Mask {
    static var cnpj: Mask {
        return .init(format: "cc.ccc.ccc/cccc-cc") { (type) -> Bool in
            switch type {
            case .character(let c, _): return c.isWholeNumber
            case .full(let string):
                let numbers = string.compactMap({ $0.wholeNumberValue })
                return numbers.count == 14 && Set(numbers).count != 1 && [12, 13].first(where: { (n) in
                    var multiplier = n - 6, digit = 11
                    digit -= (numbers.prefix(n).reduce(into: 0, {
                        multiplier += (multiplier - 1) > 1 ? -1 : 7
                        $0 += $1 * multiplier
                    }) % 11)
                    return numbers[n] != (digit >= 10 ? 0 : digit)
                }) == nil
            }
        }
    }
    
    static var cpf: Mask {
        return .init(format: "ccc.ccc.ccc-cc") { (type) -> Bool in
            switch type {
            case .character(let c, _): return c.isWholeNumber
            case .full(let string):
                let numbers = string.compactMap({ $0.wholeNumberValue })
                return numbers.count == 11 && Set(numbers).count != 1 && [9, 10].first(where: { (n) in
                    let digit = 11 - (numbers.prefix(n).enumerated().reduce(into: 0, {
                        $0 += $1.element * (n + 1 - $1.offset)
                    }) % 11)
                    return numbers[n] != (digit >= 10 ? 0 : digit)
                }) == nil
            }
        }
    }
}
