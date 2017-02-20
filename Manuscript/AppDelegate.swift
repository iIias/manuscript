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
    
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var fileMenu: NSMenu!
    @IBOutlet weak var styleMenu: NSMenu!
    @IBOutlet weak var windowMenu: NSMenu!
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize application
        styleMenu.addItem(NSMenuItem(title: "Light 💡", action: #selector(ViewController().setLightMode), keyEquivalent: ""))
        styleMenu.addItem(NSMenuItem(title: "Dark 🌚", action: #selector(ViewController().setDarkMode), keyEquivalent: ""))
    }
    
    
    func noFunction() {
        print("nothing")
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

