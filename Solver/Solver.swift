//
//  Solver.swift
//  Solver
//
//  Created by Andrew Barrett on 7/18/19.
//  Copyright © 2019 Andrew Barrett. All rights reserved.
//

import Foundation

enum Operator {
    case Addition
    case Subtraction
    case Multiplication
    case Division
}

class Solver {
    
    static func solve(numbers: inout [Double], operators: inout [Operator]) -> Double {
        if numbers.count == 1 {
            return numbers[0]
        }
        let firstMultiply = operators.firstIndex(of: .Multiplication)
        let firstDivision = operators.firstIndex(of: .Division)
        var firstOperatorIndex = 0
        if let firstM = firstMultiply, let firstD = firstDivision {
            firstOperatorIndex = min(firstM, firstD)
        } else if let firstM = firstMultiply {
            firstOperatorIndex = firstM
        } else if let firstD = firstDivision {
            firstOperatorIndex = firstD
        }
        
        let persistentIndex = firstOperatorIndex
        let op = operators[firstOperatorIndex]
        let a = numbers[firstOperatorIndex]
        let b = numbers[firstOperatorIndex+1]
        
        var updateValue = 0.0
        switch op {
        case .Addition:
            updateValue = a+b
        case .Subtraction:
            updateValue = a-b
        case .Multiplication:
            updateValue = a*b
        case .Division:
            updateValue = a/b
        }
        
        numbers[persistentIndex] = updateValue
        numbers.remove(at: persistentIndex+1)
        operators.remove(at: firstOperatorIndex)
        
        return solve(numbers: &numbers, operators: &operators)
    }
}
