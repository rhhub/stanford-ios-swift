//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ryan Huebert on 11/5/15.
//  Copyright © 2015 Ryan Huebert. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        // enum can have functions
        // enum can have properties, but only computed properties
        case Operand(Double)
        case ConstantOperation(String, Void -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            // teach enum how to turn into string
            // must be read only
            // must be named description for following protocol
            // implement CustomStringConvertible protocol
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .ConstantOperation(let symbol, _):
                    return "\(symbol)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]() // Array<Op>() define
    
    private var knownOps = [String: Op]() // Dictionary<String, Op>()
    init() {
        func learnOp(op: Op) {
            // Sets the key for the knownOps dictionary
            knownOps[op.description] = op
        }
        
        learnOp(Op.ConstantOperation("π") {M_PI})
        learnOp(Op.BinaryOperation("×", *)) // {$0 * $1}
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("+", +)) // {$0 + $1}
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt)) // { sqrt($0) })
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        
        //knownOps["√"] = Op.UnaryOperation("√", sqrt) // { sqrt($0) }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList { // guarenteed to be a PropertyList
        get {
            return opStack.map { $0.description }
            /*
            var returnValue = [String()]
            for op in opStack {
                returnValue.append(op.description)
            }
            return returnValue
            */
        }
        set {
            if let opSymbol = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbol {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        // Recursion is a method that calls itself.
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast() // Swift doesn't make an actual "copy" until this is called.
            switch op {
            case .Operand(let operand):
                return(operand, remainingOps)
            case .ConstantOperation(_, let operation):
                return(operation(), remainingOps)
            case .UnaryOperation(_, let operation):
                // Recursion and Tuple
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        
        
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
