
//
//  AppDelegate.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var fileMenu: NSMenu!
    @IBOutlet weak var editMenu: NSMenu!
    @IBOutlet weak var styleMenu: NSMenu!
    @IBOutlet weak var windowMenu: NSMenu!
    @IBOutlet weak var helpMenu: NSMenu!
    
    let ud = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize application
        windowMenu.addItem(NSMenuItem(title: "👁 Toggle Titlebar", action: #selector(Document().toggleTitlebar), keyEquivalent: "T"))
        windowMenu.addItem(NSMenuItem(title: "💡 Light", action: #selector(Document().setColorLight), keyEquivalent: "L"))
        windowMenu.addItem(NSMenuItem(title: "🌚 Dark", action: #selector(Document().setColorDark), keyEquivalent: "N"))
        windowMenu.addItem(NSMenuItem(title: "😉 Emojis", action: #selector(toggleEmojis), keyEquivalent: "E"))
    }
    
    func toggleEmojis() {
        if ud.string(forKey: "menubarStyle") == "" {
            ud.set("emoji", forKey: "menubarStyle")
            self.fileMenu.title = "📄"
            self.editMenu.title = "✍️"
            self.styleMenu.title = "🔥"
            self.windowMenu.title = "🖼"
            self.helpMenu.title = "🤦‍♂️"
        } else if ud.string(forKey: "menubarStyle") == "emoji" {
            ud.set("standard", forKey: "menubarStyle")
            self.fileMenu.title = "File"
            self.editMenu.title = "Edit"
            self.styleMenu.title = "Style"
            self.windowMenu.title = "Window"
            self.helpMenu.title = "Help"
        } else /*if defaults.string(forKey: "menubarStyle") == "emoji"*/ {
            self.ud.set("emoji", forKey: "menubarStyle")
            self.fileMenu.title = "📄"
            self.editMenu.title = "✍️"
            self.styleMenu.title = "🔥"
            self.windowMenu.title = "🖼"
            self.helpMenu.title = "🤦‍♂️"
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

