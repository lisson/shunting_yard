//
//  main.swift
//  shunting_yard
//
//  Created by andy on 2017-12-22.
//  Copyright © 2017 andy. All rights reserved.
//

import Foundation

enum Operation {
    case constant(Double)
    case unaryOperation((Double) -> Double)
    case binaryOperation((Double, Double) -> Double)
    case equals
}

var operations: Dictionary<String, Operation> =
[
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({-$0}),
        "*" : Operation.binaryOperation({$0*$1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "/" : Operation.binaryOperation({$0/$1}),
        "^" : Operation.binaryOperation({pow($0,$1)}),
        "=" : Operation.equals,
]

func calculate(notation nodes:[Node], vars userVars:Dictionary<String, Double>) -> Double
{
    var results:Stack = Stack();
    
    for n in nodes
    {
        if (n.type == NodeType.OPERAND)
        {
            results.push(n);
        }
        else if (n.type == NodeType.OPERATION)
        {
            if let op = operations[n.val]
            {
                switch op {
                case .binaryOperation(let function):
                    var op1:Double = 0;
                    var op2:Double = 0;
                    if let n = results.pop(){
                        if let d = n.dval{
                            op1 = d;
                        }
                        else
                        {
                            //Is it in the dictionary?
                            op1 = userVars[n.val] ?? 0;
                        }
                    }
                    if let n = results.pop(){
                        if let d = n.dval{
                            op2 = d;
                        }
                        else
                        {
                            //Is it in the dictionary?
                            op2 = userVars[n.val] ?? 0;
                        }
                    }
                    results.push(Node(type:NodeType.OPERAND, value:function(op2,op1) ));
                case .unaryOperation(let function):
                    var op1:Double = 0;
                    if let n = results.pop(){
                        if let d = n.dval{
                            op1 = d;
                        }
                        else
                        {
                            //Is it in the dictionary?
                            op1 = userVars[n.val] ?? 0;
                        }
                    }
                    results.push(Node(type:NodeType.OPERAND, value:function(op1) ));
                case .constant(let value):
                    results.push(Node(type:NodeType.OPERAND, value:value ));
                default:
                    print("Nothing");
                }
            }
        }
    }
    if let n = results.pop(){
        return n.dval!;
    }
    return 0.0;
}

let e = ExpressionParser()
let notation = e.parse(expression:"(2+1)");
if (notation.count == 0)
{
    print("Error");
}
else
{
    print(String(calculate(notation: notation, vars: [:])));
}





