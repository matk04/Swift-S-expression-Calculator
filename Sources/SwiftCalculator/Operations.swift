//
//  File.swift
//  
//
//  Created by Matias Koch on 13/07/2021.
//

import Foundation

protocol Operation {
    func evaluate(operands : [Int]) -> Int
}

class Addition: Operation {
    func evaluate(operands: [Int]) -> Int {
        return operands.reduce(0, +)
    }
}

class Multiplication: Operation {
    func evaluate(operands: [Int]) -> Int {
        return operands.reduce(1, *)
    }
}
