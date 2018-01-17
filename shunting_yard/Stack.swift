//
//  stack.swift
//  shunting_yard
//
//  Created by andy on 2017-12-22.
//  Copyright © 2017 andy. All rights reserved.
//

import Foundation

struct Stack{
    var head:Node? = nil
    
    mutating func push(_ n:Node)
    {
        if head == nil
        {
            head = n;
            head!.next = nil;
        }
        else
        {
            let t = head
            n.next = t;
            head = n;
        }
    }
    
    mutating public func pop() -> Node?
    {
        let r:Node?;
        if head != nil && head!.next != nil
        {
            r = head;
            head = head!.next;
        }
        else
        {
            r = head;
            head = nil;
        }
        return r;
    }
    
    func peek() -> Node?
    {
        return head;
    }
}
