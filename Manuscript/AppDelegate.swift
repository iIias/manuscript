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
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        menu.addItem(NSMenuItem(title: "Light 💡", action: #selector(ViewController.setLightMode), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Dark 🌑", action: #selector(ViewController.setDarkMode), keyEquivalent: ""))

        
        if let button = statusItem.button {
            button.title = "✏️"
            statusItem.menu = menu
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

