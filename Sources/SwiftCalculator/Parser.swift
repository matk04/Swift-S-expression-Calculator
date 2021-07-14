//
//  File.swift
//  
//
//  Created by Matias Koch on 12/07/2021.
//

import Foundation

class Parser {
            
    /// A regex to identify expressions that represents a *function*
    private lazy var regexFunction = try! NSRegularExpression(pattern: #"^\((\w+)((\s\d+|\s\(.+\)){2,})\)$"#, options: [])
        
    /// Mapping of the possible function operations and their names
    private lazy var operationMap : [String : Operation] = [
        "add" : Addition(),
        "multiply" : Multiplication()
    ]
        
    /// Evaluates the `expression` into an `Int` result.
    ///
    /// An expression can be in one of two forms:
    /// - An integer value
    /// - A function call of the form *(FUNCTION EXPR EXPR)*, where *FUNCTION* denotates the operation and *EXPR* is another `expression` that can be evaluated with this method
    /// - Parameter expression: `String` containing the expression to evaluate
    /// - Throws: a `ParseError` when the `expression` is not in the required format
    /// - Returns: an `Int` with the result
    func evaluate(expression : String) throws -> Int {
        let fullRange = expression.startIndex..<expression.endIndex
        let matches = regexFunction.matches(in: expression, options: [], range: NSRange(fullRange, in: expression))
        
        if let match = matches.first, match.numberOfRanges >= 3 {
            guard let operationName = extractValue(from: expression, inMatch: match, atIndex: 1) else {
                throw ParseError(errorType: .noOperationNameFound)
            }
            guard let operandsExpression = extractValue(from: expression, inMatch: match, atIndex: 2) else {
                throw ParseError(errorType: .noOperandsFound)
            }
            
            let operands : [Int] = try parseOperands(from: operandsExpression)
            
            if operands.count == 2 {
                guard let operation = operationMap[operationName] else {
                    throw ParseError(errorType: .invalidOperation)
                }
                                
                return operation.evaluate(operands: operands)
            }else{
                throw ParseError(errorType: .invalidOperandsCount)
            }
            
                          
        }else{
            guard let value = Int(expression.trimmingCharacters(in: .whitespaces)) else {
                throw ParseError(errorType: .numberParseFailed)
            }
            return value
        }
    }
    
    
    /// Given a `match` found in an `expression`, returns the range at `rangeIndex`
    /// - Parameters:
    ///   - expression: `String` containing the *match*
    ///   - match: `NSTextCheckingResult` found inside the *expression*
    ///   - rangeIndex: `Int` indicating the index of the desired range inside the *match*
    /// - Returns: The `String` at the desired range or `nil` if the range is invalid
    private func extractValue(from expression : String, inMatch match : NSTextCheckingResult, atIndex rangeIndex : Int) -> String? {
        if let matchRange = Range(match.range(at: rangeIndex), in: expression) {
            return String(expression[matchRange])
        }else{
            return nil
        }
    }
    
    
    /// Extracts the operands of an expression. If an operand contains an expression, it will be evaluated first.
    /// - Parameter expression: `String` containing only the operands separated by a space character
    /// - Throws: a `ParseError` when the `expression` contains unbalanced parenthesis
    /// - Returns: an `Array` of integers containing the operands
    private func parseOperands(from expression : String) throws -> [Int] {
        var operands : [Int] = []
        var parenthesisCounter = 0
        var operandExpressionBuffer = ""
        
        for idx in expression.indices {
            let char = expression[idx]
            if char != " " || !operandExpressionBuffer.isEmpty{
                operandExpressionBuffer.append(char)
            }
            if char == "(" {
                parenthesisCounter += 1
            }else if char == ")" {
                parenthesisCounter -= 1
            }
            if !operandExpressionBuffer.isEmpty, parenthesisCounter == 0, char == " " || char == ")" || idx == expression.indices.last {
                let operand = try evaluate(expression: operandExpressionBuffer)
                operands.append(operand)
                operandExpressionBuffer = ""
            }
        }
        if parenthesisCounter > 0 {
            throw ParseError(errorType: .unbalancedParenthesis)
        }
        
        return operands
    }
    
}
