//
//  Json.swift
//  SwiftJsonDemo
//
//  Created by 童进 on 15/11/4.
//  Copyright © 2015年 qefee. All rights reserved.
//

import Foundation

/// JsonParser class
public class JsonParser {
    /**
     parse NSData
     
     - parameter data: NSData
     - parameter opt:  NSJSONReadingOptions(default = AllowFragments)
     
     - returns: Json
     */
    public class func p(data: NSData, options opt: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments) -> Json {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: opt)
            
            return Json(value: json)
        } catch let error {
            NSLog(String(error))
        }
        
        return Json.NullElement
    }
    
    /**
     parse String
     
     - parameter string:   String
     - parameter encoding: NSStringEncoding
     - parameter opt:      NSJSONReadingOptions(default = AllowFragments)
     
     - returns: Json
     */
    public class func p(string: String, encoding: NSStringEncoding=NSUTF8StringEncoding, options opt: NSJSONReadingOptions=NSJSONReadingOptions.AllowFragments) -> Json {
        let data = string.dataUsingEncoding(encoding)
        
        if let d = data {
            return p(d, options: opt)
        }
        return Json.NullElement
    }
}
