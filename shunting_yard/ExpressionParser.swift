//
//  ExpressionParser.swift
//  shunting_yard
//
//  Created by andy on 2018-01-13.
//  Copyright © 2018 andy. All rights reserved.
//

import Foundation

struct ExpressionParser{
    //BEDMAS
    private let Operators:[String] = ["-","+","/","*","±","^","√","(",")"]
    
    //Returns in reverse polish notation
    public func parse(expression:String) -> [Node]
    {
        var output:Queue = Queue()
        var operators:Stack = Stack()
        
        let tokens = tokenise(expression:expression);
        for token in tokens
        {
            if (token.type == NodeType.OPERAND)
            {
                output.push(token);
            }
            else if (token.type == NodeType.OPERATION)
            {
                var head:Node? = operators.peek()
                var token_precedence:Int = -1;
                if let t = Operators.index(of:token.val)
                {
                    token_precedence = t;
                }
                while head != nil && head!.type != NodeType.LBRACKET
                {
                    if let head_precedence = Operators.index(of:head!.val)
                    {
                        if head_precedence > token_precedence
                        {
                            output.push(operators.pop()!);
                            head = operators.peek();
                        }
                        else
                        {
                            break;
                        }
                    }
                }
                operators.push(token);
            }
            else if (token.type == NodeType.RBRACKET)
            {
                var head:Node? = operators.peek()
                while head != nil && head!.type != NodeType.LBRACKET
                {
                    output.push(operators.pop()!);
                    head = operators.peek();
                }
                if (head != nil && head!.type == NodeType.LBRACKET)
                {
                    //discard the ")"
                    operators.pop();
                }
                else if (head == nil)
                {
                    //Error
                    return [];
                }
            }
            else
            {
                operators.push(token);
            }
        }
        
        var head:Node? = operators.peek()
        while head != nil
        {
            output.push(operators.pop()!);
            head = operators.peek();
        }
        
        var return_value:[Node] = [];
        var n:Node? = output.pop();
        while n != nil
        {
            if (n!.type == NodeType.LBRACKET || n!.type == NodeType.RBRACKET)
            {
                //error
                return [];
            }
            return_value.append(n!);
            n = output.pop();
        }
        return return_value;
    }
    
    private func tokenise(expression:String) -> [Node]
    {
        var tokens:[String] = []
        var current_token:String = ""
        for c in expression
        {
            if (Operators.contains(String(c)))
            {
                if (current_token != "")
                {
                    tokens.append(current_token);
                }
                tokens.append(String(c));
                current_token = "";
            }
            else
            {
                current_token = current_token + String(c)
            }
        }
        if (current_token != "")
        {
            tokens.append(current_token);
        }
        
        return convert_nodes(input:tokens);
    }
    
    private func convert_nodes(input:[String]) -> [Node]
    {
        var output:Array<Node> = []
        for s in input
        {
            if (Operators.contains(s))
            {
                switch (s)
                {
                case "(": output.append(Node(type:NodeType.LBRACKET, value:s));
                case ")": output.append(Node(type:NodeType.RBRACKET, value:s));
                default: output.append(Node(type:NodeType.OPERATION, value:s));
                }
                
            }
            else
            {
                output.append(Node(type:NodeType.OPERAND, value:s, next:nil));
            }
        }
        return output;
    }
}
