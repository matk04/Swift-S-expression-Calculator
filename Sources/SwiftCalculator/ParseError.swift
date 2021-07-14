//
//  File.swift
//  
//
//  Created by Matias Koch on 14/07/2021.
//

import Foundation

struct ParseError : Error {
    let errorType : ParseErrorType
}

enum ParseErrorType {
    case unbalancedParenthesis
    case invalidOperandsCount
    case invalidOperation
    case numberParseFailed
    case invalidSyntax
    case noOperationNameFound
    case noOperandsFound
}
