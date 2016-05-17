//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Apple3 on 10/05/16.
//  Copyright © 2016 Apple3. All rights reserved.
//

import Foundation
class CalculatorBrain
{
    private enum Op //:printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double ->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        
        var discription: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        
          func learnOp( op : Op){
            knownOps[op.discription] = op
           }
        learnOp(Op.BinaryOperation("×", *))
        //knownOps["×"] = Op.BinaryOperation("", *)
        knownOps["÷"] = Op.BinaryOperation(""){$1 / $0}
        knownOps["+"] = Op.BinaryOperation("", +)
        knownOps["−"] = Op.BinaryOperation(""){$1 - $0}
        knownOps["√"] = Op.UnaryOperation("", sqrt)
    }
    
        var program: AnyObject{ //granteed to be a propertyList
            get{
    //            var returnValue = Array<String>()
    //            for op in opStack{
    //                returnValue.append(op.discription)
    //            }
    //            return returnValue
                return opStack.map { $0.discription }
            }set {
                if let opSymbols = newValue as? Array<String>{
                    var newOpStack = [Op]()
                    for opSymbol in opSymbols {
                        if let op = knownOps[opSymbol]{
                            newOpStack.append(op)
                        }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                            newOpStack.append(.Operand(operand))
                        }
                    }
                    opStack = newOpStack
                }
            }
    
        }
    private func evaluate(ops: [Op]) -> (result: Double?, remaningOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation  = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remaningOps )
                }
            case .BinaryOperation(_ , let operation):
                let op1Evaluation = evaluate( remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remaningOps)
                    }
                    
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) lef over ")
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbole: String) -> Double?{
        if let operation = knownOps[symbole]{
            opStack.append(operation)
        }
        return evaluate()
    }
}