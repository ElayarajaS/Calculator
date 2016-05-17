//
//  ViewController.swift
//  Calculator
//
//  Created by Apple3 on 10/05/16.
//  Copyright © 2016 Apple3. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfATypingANumber: Bool = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfATypingANumber {
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfATypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfATypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfATypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    var displayValue :Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfATypingANumber = false
        }
    }
    
}
