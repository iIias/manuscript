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
    let modesMenu: NSMenu = NSMenu(title: "Modes 🔥")
    let saveMenu: NSMenu = NSMenu(title: "Save 📋")
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let modesItem = NSMenuItem(title: "🔥 Modes", action: #selector(self.noFunction), keyEquivalent: "")
        let saveItem = NSMenuItem(title: "💾 Save", action: #selector(ViewController.saveTextToDocuments), keyEquivalent: "")
        menu.addItem(saveItem)
        saveMenu.addItem(NSMenuItem(title: "📄 Documents", action: #selector(ViewController.saveTextToDocuments), keyEquivalent: ""))
        saveMenu.addItem(NSMenuItem(title: "🏠 Desktop", action: #selector(ViewController.saveTextToDocuments), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(modesItem)
        modesMenu.addItem(NSMenuItem(title: "Light 💡", action: #selector(ViewController.setLightMode), keyEquivalent: ""))
        modesMenu.addItem(NSMenuItem(title: "Dark 🌑", action: #selector(ViewController.setDarkMode), keyEquivalent: ""))
        modesItem.submenu = modesMenu
        saveItem.submenu = saveMenu
        
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

