//
//  JsonToObjWindowController.swift
//  SwiftJsonToObj
//
//  Created by 童进 on 15/12/21.
//  Copyright © 2015年 qefee. All rights reserved.
//

import Cocoa

class JsonToObjWindowController: NSWindowController {

    @IBOutlet weak var classNameTextField: NSTextField!
    @IBOutlet weak var msgTextField: NSTextField!
    
    @IBOutlet var jsonTextView: NSTextView!
    @IBOutlet var objTextView: NSTextView!
    
    
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func onClearButtonClick(sender: NSButton) {
        classNameTextField.stringValue = ""
        msgTextField.stringValue = "Msg: "
        jsonTextView.string = ""
        objTextView.string = ""
    }
    
    @IBAction func onSubmitButtonClick(sender: NSButton) {
        msgTextField.stringValue = "Msg: "
        
        let className = classNameTextField.stringValue
        if className == "" {
            showMsg("className = \"\"")
        } else {
            let jsonString = jsonTextView.string
            
            if let jsonStr = jsonString {
                let json = JsonParser.p(jsonStr)
                
                switch json.value {
                case .DictionaryType:
                    let classStr = getClassString(className, json: json)
                    objTextView.string =  classStr
                default:
                    showMsg("jsonString format error")
                }
            } else {
                showMsg("jsonString = nil")
            }
        }
    }
    
    func getClassString(clsName: String, json: Json) -> String {
        var outStr = ""
        let classStart = "class \(clsName) {" + "\r\n"
        let classEnd = "}"
        
        outStr += classStart
        
        for (key, subJson) in json.dictionaryValue {
            switch subJson.value {
            case .StringType:
                outStr += "    var \(key): String?" + "\r\n"
            case .BoolType:
                outStr += "    var \(key): Bool?" + "\r\n"
            case .IntType:
                outStr += "    var \(key): Int?" + "\r\n"
            case .FloatType:
                outStr += "    var \(key): Float?" + "\r\n"
            case .DoubleType:
                outStr += "    var \(key): Double?" + "\r\n"
            case .ArrayType:
                let arr = subJson.arrayValue
                
                if arr.count == 0 {
                    outStr += "    var \(key): [AnyObject]?" + "\r\n"
                } else {
                    switch arr[0].value {
                    case .StringType:
                        outStr += "    var \(key): [String]?" + "\r\n"
                    case .BoolType:
                        outStr += "    var \(key): [Bool]?" + "\r\n"
                    case .IntType:
                        outStr += "    var \(key): [Int]?" + "\r\n"
                    case .FloatType:
                        outStr += "    var \(key): [Float]?" + "\r\n"
                    case .DoubleType:
                        outStr += "    var \(key): [Double]?" + "\r\n"
                    case .DictionaryType:
                        let firstChar = key.substringToIndex(key.startIndex.advancedBy(1))
                        let otherString = key.substringFromIndex(key.startIndex.advancedBy(1))
                        let clsName = firstChar.uppercaseString + otherString + "Obj"
                        outStr = getClassString(clsName, json: arr[0]) + outStr
                        outStr += "    var \(key): [\(clsName)]?" + "\r\n"
                    default:
                        break
                    }
                }
            case .DictionaryType:
                let firstChar = key.substringToIndex(key.startIndex.advancedBy(1))
                let otherString = key.substringFromIndex(key.startIndex.advancedBy(1))
                let clsName = firstChar.uppercaseString + otherString + "Obj"
                outStr = getClassString(clsName, json: subJson) + outStr
                outStr += "    var \(key): \(clsName)?" + "\r\n"
            default:
                break
            }
        }
        
        outStr += classEnd + "\r\n"
        
        return outStr
    }
    
    func showMsg(msg: String) {
        msgTextField.stringValue = "Msg: " + msg
    }
    
}
