//
//  NSObject_Extension.swift
//
//  Created by 童进 on 15/12/21.
//  Copyright © 2015年 qefee. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = SwiftJsonToObj(bundle: bundle)
        	}
        }
    }
}