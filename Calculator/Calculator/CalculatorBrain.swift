//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 暴躁 on 6/25/19.
//  Copyright © 2019 Jambako. All rights reserved.
//

import Foundation

struct CalculatorBrain {//struct-non-inheritance-pass by coping-value types has own initializer || class-inheritance-in heap,pointer-reference type
    private var accumulator:Double? //internal
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
    }
    
    private var operations:Dictionary<String,Operation>=[
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "∛": Operation.unaryOperation(cbrt),
        "sin": Operation.unaryOperation(sin),
        "cos": Operation.unaryOperation(cos),
        "tan": Operation.unaryOperation(tan),
        "±": Operation.unaryOperation({-$0}),
        "x²": Operation.unaryOperation({$0 * $0}),
        "x³": Operation.unaryOperation({$0 * $0 * $0}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "−": Operation.binaryOperation({$0 - $1}),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation=operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function:(Double,Double)->Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double)->Double{
            return function(firstOperand,secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result:Double?{
        get{
            return accumulator
        }
    }
}
