//
//  JsonType.swift
//  SwiftJsonDemo
//
//  Created by 童进 on 15/11/5.
//  Copyright © 2015年 qefee. All rights reserved.
//

import Foundation

/**
 *  JsonValue enum
 */
public enum JsonValue {
    // enum cases
    case StringType(String)
    case IntType(Int)
    case FloatType(Float)
    case DoubleType(Double)
    case BoolType(Bool)
    case NullType
    
    // collection types
    case DictionaryType(Dictionary<String,AnyObject>)
    case ArrayType([AnyObject])
}