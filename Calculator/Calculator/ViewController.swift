//
//  ViewController.swift
//  Calculator
//
//  Created by 暴躁 on 6/24/19.
//  Copyright © 2019 Jambako. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!//=nil- not set optional
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit=sender.currentTitle! //constant -let, it does not change. !-decided the type-optional set state. ?-not decided type
        if userIsInTheMiddleOfTyping{
            let testCurrentlyInDisplay = display.text!
            display.text = testCurrentlyInDisplay+digit}
        else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        if let result=brain.result{
            displayValue=result
        }
        
    }
    
}

