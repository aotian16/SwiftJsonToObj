//
//  Json.swift
//  SwiftJsonDemo
//
//  Created by 童进 on 15/11/4.
//  Copyright © 2015年 qefee. All rights reserved.
//

import Foundation

/// Json class
public class Json {
    /// print log when true
    public static var logEnable: Bool = true
    /// NullElement
    public static var NullElement: Json = Json()
    /// value of Json
    public var value: JsonValue = JsonValue.NullType
    /// cache of dictionary
    private var dictionaryCache: Dictionary<String,Json>?
    /// cache of array
    private var arrayCache: Array<Json>?
    
    private init() {
    }
    
    /**
     init
     
     - parameter value: AnyObject?
     
     - returns: NullElement
     */
    public init(value: AnyObject) {
        
        if "\(value.dynamicType)" == "__NSCFBoolean" {
            let v = value as! Bool
            self.value = .BoolType(v)
        } else if value is NSNumber {
            
            let cfnumber = value as! CFNumberRef
            let type = CFNumberGetType(cfnumber)
            
            //            print(type.rawValue)
            //            CFNumberType
            //            kCFNumberSInt8Type
            //            kCFNumberFloat32Type
            switch type {
            case CFNumberType.SInt8Type:
                fallthrough
            case CFNumberType.SInt16Type:
                fallthrough
            case CFNumberType.SInt32Type:
                fallthrough
            case CFNumberType.SInt64Type:
                fallthrough
            case CFNumberType.CharType:
                fallthrough
            case CFNumberType.IntType:
                fallthrough
            case CFNumberType.ShortType:
                fallthrough
            case CFNumberType.LongType:
                fallthrough
            case CFNumberType.LongLongType:
                let v = value as! Int
                self.value = .IntType(v)
            case CFNumberType.FloatType:
                fallthrough
            case CFNumberType.Float32Type:
                fallthrough
            case CFNumberType.Float64Type:
                fallthrough
            case CFNumberType.CGFloatType:
                let v = value as! Float
                self.value = .FloatType(v)
            case CFNumberType.DoubleType:
                let v = value as! Double
                self.value = .DoubleType(v)
            default:
                let v = value as! Int
                self.value = .IntType(v)
                break
            }
        } else if value is String {
            let v = value as! String
            self.value = .StringType(v)
        } else if value is Bool {
            let v = value as! Bool
            self.value = .BoolType(v)
        } else if value is Dictionary<String,AnyObject> {
            let v = value as! Dictionary<String,AnyObject>
            self.value = .DictionaryType(v)
        } else if value is Array<AnyObject> {
            let v = value as! Array<AnyObject>
            self.value = .ArrayType(v)
        } else {
            self.value = .NullType
        }
    }
}

// value of Json
extension Json {
    /// string? value
    public var string: String? {
        switch self.value {
        case .StringType(let v):
            return v
        default:
            return nil
        }
    }
    /// string value(default = "")
    public var stringValue: String {
        if let s = string {
            return s
        }
        return ""
    }
    /// int? value
    public var int: Int? {
        switch self.value {
        case .IntType(let v):
            return v
        default:
            return nil
        }
    }
    /// int value(default = -1)
    public var intValue: Int {
        if let i = int {
            return i
        }
        return -1
    }
    /// float? value
    public var float: Float? {
        switch self.value {
        case .FloatType(let v):
            return v
        default:
            return nil
        }
    }
    /// float value(default = -1)
    public var floatValue: Float {
        if let f = float {
            return f
        }
        return -1
    }
    /// double value
    public var double: Double? {
        switch self.value {
        case .DoubleType(let v):
            return v
        default:
            return nil
        }
    }
    /// double value(default = -1)
    public var doubleValue: Double {
        if let d = double {
            return d
        }
        return -1
    }
    /**
     bool? value
     
     1. if BoolType     return bool
     2. if IntType,FloatType,DoubleType return true when value != 0
     3. if StringType   return true when value != ""
     */
    public var bool: Bool? {
        switch self.value {
        case .BoolType(let v):
            return v
        case .IntType(let v):
            if v == 0 {
                return false
            } else {
                return true
            }
        case .FloatType(let v):
            if v == 0 {
                return false
            } else {
                return true
            }
        case .DoubleType(let v):
            if v == 0 {
                return false
            } else {
                return true
            }
        case .StringType(let v):
            if v == "" {
                return false
            } else {
                return true
            }
        default:
            return nil
        }
    }
    /**
     bool value(default = false)
     
     1. if BoolType     return bool
     2. if NSNumberType return true when value != 0
     3. if StringType   return true when value != ""
     */
    public var boolValue: Bool {
        if let b = bool {
            return b
        }
        return false
    }
    /// dictionary? value
    public var dictionary: Dictionary<String,Json>? {
        switch self.value {
        case .DictionaryType(let value):
            if let dic = dictionaryCache {
                return dic
            } else {
                var dic = Dictionary<String,Json>()
                
                for (k,v) in value {
                    dic[k] = Json(value: v)
                }
                dictionaryCache = dic
                return dic
            }
            
        default:
            return nil
        }
    }
    /// dictionary value(default = empty dictionary)
    public var dictionaryValue: Dictionary<String,Json> {
        if let dic = dictionary {
            return dic
        }
        return Dictionary<String,Json>()
    }
    /// array value
    public var array: Array<Json>? {
        switch self.value {
        case .ArrayType(let value):
            if let arr = arrayCache {
                return arr
            } else {
                var arr = Array<Json>()
                
                for v in value {
                    arr.append(Json(value: v))
                }
                arrayCache = arr
                return arr
            }
        default:
            return nil
        }
    }
    /// array value(default = empty array)
    public var arrayValue: Array<Json> {
        if let arr = array {
            return arr
        }
        return Array<Json>()
    }
}

extension Json {
    /**
     sub element of Json(DictionaryType)
     
     - parameter key: key
     
     - returns: Json. NullElement if not found
     */
    public subscript(key: String) -> Json {
        if let dic = dictionary {
            if let v = dic[key] {
                return v
            } else {
                jsonLog("can not find value by key = \(key)")
            }
        } else {
            jsonLog("dictionary = nil")
        }
        return Json.NullElement
    }
    /**
     sub element of Json(ArrayType)
     
     - parameter index: index
     
     - returns: Json. NullElement if not found
     */
    public subscript(index: Int) -> Json {
        if let arr = array {
            if index < arr.count && index >= 0 {
                return arr[index]
            } else {
                jsonLog("index error. count = \(arr.count), index = \(index)")
            }
        } else {
            jsonLog("array = nil")
        }
        return Json.NullElement
    }
}

extension Json {
    /**
     NullType check.
     
     - returns: true if NullType
     */
    public func isNull() -> Bool {
        switch self.value {
        case .NullType:
            return true
        default:
            return false
        }
    }
}

extension Json {
    /**
     print log when Json.logEnable = true
     
     - parameter msg: message to log
     */
    private func jsonLog(msg: String) {
        if Json.logEnable {
            NSLog("SwiftJson Log: \(msg)")
        }
    }
}