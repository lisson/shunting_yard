//
//  Node.swift
//  shunting_yard
//
//  Created by andy on 2018-01-13.
//  Copyright © 2018 andy. All rights reserved.
//

import Foundation

enum NodeType {
    case OPERAND
    case OPERATION
    case LBRACKET
    case RBRACKET
}

class Node {
    var type:NodeType = NodeType.OPERAND
    var val:String = ""
    var dval:Double? = nil;
    var next:Node? = nil
    
    init(type:NodeType, value:String)
    {
        self.type = type;
        self.val = value;
        
        convert();
    }
    
    init(type:NodeType, value:String, next:Node?)
    {
        self.type = type;
        self.val = value;
        self.next = next;
        
        convert();
    }
    
    init(type:NodeType, value:Double)
    {
        self.type = type;
        self.dval = value;
        self.val = "";
    }
    
    public func convert()
    {
        dval = Double(val);
    }
}
