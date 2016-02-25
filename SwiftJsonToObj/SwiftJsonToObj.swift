//
//  SwiftJsonToObj.swift
//
//  Created by 童进 on 15/12/21.
//  Copyright © 2015年 qefee. All rights reserved.
//

import AppKit

var sharedPlugin: SwiftJsonToObj?

class SwiftJsonToObj: NSObject {

    var bundle: NSBundle
    lazy var center = NSNotificationCenter.defaultCenter()

    init(bundle: NSBundle) {
        self.bundle = bundle

        super.init()
        center.addObserver(self, selector: Selector("createMenuItems"), name: NSApplicationDidFinishLaunchingNotification, object: nil)
    }

    deinit {
        removeObserver()
    }

    func removeObserver() {
        center.removeObserver(self)
    }

    func createMenuItems() {
        removeObserver()
        
        if let mainMenu = NSApp.mainMenu {
            if let item = mainMenu.itemWithTitle("Edit") {
                if let subMenu = item.submenu {
                    let title = "jsonToObj"
                    let action: Selector = Selector(title + "Action")
                    let actionMenuItem = NSMenuItem(title: title, action: action, keyEquivalent:"")
                    actionMenuItem.target = self
                    subMenu.addItem(NSMenuItem.separatorItem())
                    subMenu.addItem(actionMenuItem)
                } else {
                    showAlert("no subMenu")
                }
            } else {
                showAlert("no Edit item")
            }
        } else {
            showAlert("no mainMenu")
        }
    }

    let jsonToObjWindowController = JsonToObjWindowController(windowNibName: "JsonToObjWindowController")
    
    func jsonToObjAction() {
        jsonToObjWindowController.showWindow(jsonToObjWindowController)
    }
    
    func showAlert(message: String) {
        let error = NSError(domain: message, code:-1, userInfo:nil)
        NSAlert(error: error).runModal()
    }
}

