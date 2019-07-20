//
//  ViewController.swift
//  Solver
//
//  Created by Andrew Barrett on 7/17/19.
//  Copyright © 2019 Andrew Barrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var equationField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equationField.addTarget(self, action: #selector(donePressed), for: .editingDidEndOnExit)
        // Do any additional setup after loading the view.
    }
    
    enum MyError: Error {
        case parsingError
    }
    
    @objc func donePressed() {
        do {
            try analyzeText()
        } catch MyError.parsingError {
            print("The input \"\(self.equationField.text ?? "")\" could not be parsed.")
            let alert = UIAlertController(title: "Error", message: "Invalid equation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    func analyzeText() throws {
        if let text = self.equationField.text {
            
            // 1. Validate
            
            // Guard against empty string
            guard text.isEmpty == false else {
                return;
            }
            
            // Must start and end with a digit.
            let regex = NSRegularExpression("^[\\d]+.*[\\d]$")
            guard regex.matches(text) else {
                throw MyError.parsingError
            }
            
            var operators:[Operator] = []
            let operator_set = ["+", "-", "*", "/"]
            
            var numbers:[Double] = []
            var startIndex = 0
            
            for i in 0..<text.count {
                let character = String(text[i])
                if operator_set.contains(character) {
                    if i > 0 && operator_set.contains(String(text[i-1])) {
                        throw MyError.parsingError
                    }
                    if let number = Double(String(text[startIndex..<i])) {
                        numbers.append(number)
                        startIndex = i+1
                    } else {
                        throw MyError.parsingError
                    }
                }
                if character == "+" {
                    operators.append(.Addition)
                } else if character == "-" {
                    operators.append(.Subtraction)
                } else if character == "*" {
                    operators.append(.Multiplication)
                } else if character == "/" {
                    operators.append(.Division)
                }
            }
            
            if let lastNumber = Double(String(text[startIndex..<text.count])) {
                numbers.append(lastNumber)
            } else {
                throw MyError.parsingError
            }
            
            let output = Solver.solve(numbers: &numbers, operators: &operators)
            self.outputLabel.text = NSString(format: "%.2f", output) as String
        }
    }
    
}

