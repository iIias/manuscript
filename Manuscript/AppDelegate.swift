//
//  AppDelegate.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let menu: NSMenu = NSMenu()
    let modesMenu: NSMenu = NSMenu(title: "Modes")
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let modesItem = NSMenuItem(title: "Modes", action: #selector(self.noFunction), keyEquivalent: "")
        menu.addItem(modesItem)
        modesMenu.addItem(NSMenuItem(title: "Light 💡", action: #selector(ViewController.setLightMode), keyEquivalent: ""))
        modesMenu.addItem(NSMenuItem(title: "Dark 🌑", action: #selector(ViewController.setDarkMode), keyEquivalent: ""))
        modesItem.submenu = modesMenu
        
        if let button = statusItem.button {
            button.title = "✏️"
            statusItem.menu = menu
        }
    }
    
    func noFunction() {
        print("nothing")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

