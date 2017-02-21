//
//  AppDelegate.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTextDelegate, NSTextFieldDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var fileMenu: NSMenu!
    @IBOutlet weak var editMenu: NSMenu!
    @IBOutlet weak var styleMenu: NSMenu!
    @IBOutlet weak var windowMenu: NSMenu!
    @IBOutlet weak var helpMenu: NSMenu!
    let testDummie = NSMenuItem(title: "info", action: #selector(noFunction), keyEquivalent: "")
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize application
        styleMenu.addItem(NSMenuItem(title: "Light 💡", action: #selector(ViewController().setLightMode), keyEquivalent: ""))
        styleMenu.addItem(NSMenuItem(title: "Dark 🌚", action: #selector(ViewController().setDarkMode), keyEquivalent: ""))
        styleMenu.addItem(NSMenuItem(title: "Emojis", action: #selector(ViewController().toggleEmojis), keyEquivalent: ""))
        styleMenu.addItem(testDummie)
    }
    
    func noFunction() {
        print("nothing")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

