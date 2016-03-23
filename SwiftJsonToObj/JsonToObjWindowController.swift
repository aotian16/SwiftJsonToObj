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
    
    @IBOutlet weak var formatSegmentedControl: NSSegmentedControl!
    
    
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
                    let classObj = getClassObj(className, json: json)
                    
                    
                    print(getClassObjString1(classObj))
                    
                    let index = formatSegmentedControl.selectedSegment
                    
                    switch index {
                    case 0: // normal
                        objTextView.string =  getClassObjString(classObj)
                    default: // swiftjson
                        objTextView.string =  getClassObjString1(classObj)
                    }
                default:
                    showMsg("jsonString format error")
                }
            } else {
                showMsg("jsonString = nil")
            }
        }
    }
    
    func getClassObjString1(cls: ClassObj) -> String {
        var clsStr = "class \(cls.name) {" + "\r\n"
        if let subClsArr = cls.subclassObjArray {
            for subCls in subClsArr {
                let subClsStr = getClassObjString1(subCls)
                clsStr = subClsStr + clsStr
            }
        }
        if let attrs = cls.attributeArray {
            for attr in attrs {
                clsStr += "    var \(attr.name): \(attr.type)? {" + "\r\n"
                
                if attr.type.containsString("[") && attr.type.containsString("]") { // array
                    
                    if attr.type.containsString("Obj") { // object
//                        let range = Range<String.Index>(start: attr.type.startIndex.advancedBy(1), end: attr.type.endIndex.advancedBy(-1))
                        
                        let range = Range(attr.type.startIndex.advancedBy(1)..<attr.type.endIndex.advancedBy(-1))
                        let ojbStr = attr.type.substringWithRange(range)
                        clsStr += "        if let arr = json[\"\(attr.name)\"].array {" + "\r\n"
                        clsStr += "            var tempArr = [\(ojbStr)]()" + "\r\n"
                        clsStr += "            for item in arr {" + "\r\n"
                        clsStr += "                tempArr.append(\(ojbStr)(json: item))" + "\r\n"
                        clsStr += "            }" + "\r\n"
                        clsStr += "            return tempArr" + "\r\n"
                        clsStr += "        } else {" + "\r\n"
                        clsStr += "            return nil" + "\r\n"
                        clsStr += "        }" + "\r\n"
                    } else { // base
//                        let range = Range<String.Index>(start: attr.type.startIndex.advancedBy(1), end: attr.type.endIndex.advancedBy(-1))
                        
                        let range = Range(attr.type.startIndex.advancedBy(1)..<attr.type.endIndex.advancedBy(-1))
                        let ojbStr = attr.type.substringWithRange(range)
                        clsStr += "        if let arr = json[\"\(attr.name)\"].array {" + "\r\n"
                        clsStr += "            var tempArr = [\(ojbStr)]()" + "\r\n"
                        clsStr += "            for item in arr {" + "\r\n"
                        clsStr += "                tempArr.append(item.\(ojbStr.lowercaseString)Value)" + "\r\n"
                        clsStr += "            }" + "\r\n"
                        clsStr += "            return tempArr" + "\r\n"
                        clsStr += "        } else {" + "\r\n"
                        clsStr += "            return nil" + "\r\n"
                        clsStr += "        }" + "\r\n"
                    }
                } else if attr.type.containsString("Obj"){ // object
                    clsStr += "        if json[\"\(attr.name)\"].isNull() {" + "\r\n"
                    clsStr += "            return nil" + "\r\n"
                    clsStr += "        } else {" + "\r\n"
                    clsStr += "            return \(attr.type)(json: json[\"\(attr.name)\"])" + "\r\n"
                    clsStr += "        }" + "\r\n"
                } else { // base
                    clsStr += "        return json[\"\(attr.name)\"].\(attr.type.lowercaseString)" + "\r\n"
                }
                clsStr += "    }" + "\r\n"
            }
        }
        
        // json
        clsStr += "    var json: Json!" + "\r\n"
        clsStr += "    init(json: Json) {" + "\r\n"
        clsStr += "        self.json = json" + "\r\n"
        clsStr += "    }" + "\r\n"
        
        // ok
        clsStr += "    var isInitOk: Bool {" + "\r\n"
        if let attrs = cls.attributeArray {
            for attr in attrs {
                clsStr += "        if \(attr.name) == nil { return false }" + "\r\n"
            }
        }
        clsStr += "        return true" + "\r\n"
        clsStr += "    }" + "\r\n"
        
        clsStr += "}" + "\r\n"
        return clsStr
    }
    
    func getClassObjString(cls: ClassObj) -> String {
        var clsStr = "class \(cls.name) {" + "\r\n"
        if let subClsArr = cls.subclassObjArray {
            for subCls in subClsArr {
                let subClsStr = getClassObjString(subCls)
                clsStr = subClsStr + clsStr
            }
        }
        if let attrs = cls.attributeArray {
            for attr in attrs {
                clsStr += "    var \(attr.name): \(attr.type)?" + "\r\n"
            }
        }
        
        // ok
        clsStr += "    var isInitOk: Bool {" + "\r\n"
        if let attrs = cls.attributeArray {
            for attr in attrs {
                clsStr += "        if \(attr.name) == nil { return false }" + "\r\n"
            }
        }
        clsStr += "        return true" + "\r\n"
        clsStr += "    }" + "\r\n"
        
        clsStr += "}" + "\r\n"
        return clsStr
    }
    
    func getClassObj(clsName: String, json: Json) -> ClassObj {
        let classObj = ClassObj()
        classObj.name = clsName
        
        if let dict = json.dictionary {
            if dict.count > 0 {
                var attributeArray = [AttributeObj]()
                for (key, subJson) in dict {
                    let attributeObj = AttributeObj()
                    attributeObj.name = key
                    switch subJson.value {
                    case .StringType:
                        attributeObj.type = "String"
                    case .BoolType:
                        attributeObj.type = "Bool"
                    case .IntType:
                        attributeObj.type = "Int"
                    case .FloatType:
                        attributeObj.type = "Float"
                    case .DoubleType:
                        attributeObj.type = "Double"
                    case .ArrayType:
                        let arr = subJson.arrayValue
                        
                        if arr.count == 0 {
                            attributeObj.type = "[AnyObject]"
                        } else {
                            switch arr[0].value {
                            case .StringType:
                                attributeObj.type = "[String]"
                            case .BoolType:
                                attributeObj.type = "[Bool]"
                            case .IntType:
                                attributeObj.type = "[Int]"
                            case .FloatType:
                                attributeObj.type = "[Float]"
                            case .DoubleType:
                                attributeObj.type = "[Double]"
                            case .DictionaryType:
                                let firstChar = key.substringToIndex(key.startIndex.advancedBy(1))
                                let otherString = key.substringFromIndex(key.startIndex.advancedBy(1))
                                let clsName = firstChar.uppercaseString + otherString + "Obj"
                                let subClassObj = getClassObj(clsName, json: arr[0])
                                if let _ = classObj.subclassObjArray {
                                    classObj.subclassObjArray!.append(subClassObj)
                                } else {
                                    var subClassObjArray = [ClassObj]()
                                    subClassObjArray.append(subClassObj)
                                    classObj.subclassObjArray = subClassObjArray
                                }
                                attributeObj.type = "[\(clsName)]"
                            default:
                                break
                            }
                        }
                    case .DictionaryType:
                        let firstChar = key.substringToIndex(key.startIndex.advancedBy(1))
                        let otherString = key.substringFromIndex(key.startIndex.advancedBy(1))
                        let clsName = firstChar.uppercaseString + otherString + "Obj"
                        let subClassObj = getClassObj(clsName, json: subJson)
                        if let _ = classObj.subclassObjArray {
                            classObj.subclassObjArray!.append(subClassObj)
                        } else {
                            var subClassObjArray = [ClassObj]()
                            subClassObjArray.append(subClassObj)
                            classObj.subclassObjArray = subClassObjArray
                        }
                        attributeObj.type = "\(clsName)"
                    default:
                        break
                    }
                    
                    attributeArray.append(attributeObj)
                }
                classObj.attributeArray = attributeArray
            } else {
                // TODO
            }
        } else {
            // TODO
        }
        return classObj
    }
    
    func showMsg(msg: String) {
        msgTextField.stringValue = "Msg: " + msg
    }
    
}

class ClassObj {
    var name: String!
    var attributeArray: [AttributeObj]?
    var subclassObjArray: [ClassObj]?
}

class AttributeObj {
    var type: String!
    var name: String!
}
