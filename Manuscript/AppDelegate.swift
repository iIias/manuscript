//
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
    @IBOutlet weak var windowMenu: NSMenu!
    @IBOutlet weak var shareMenu: NSMenu!
    @IBOutlet weak var helpMenu: NSMenu!
        
    let ud = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize application
        windowMenu.addItem(NSMenuItem.separator())
        windowMenu.addItem(NSMenuItem(title: "👁 Toggle Titlebar", action: #selector(Document().toggleTitlebar), keyEquivalent: "T"))
        windowMenu.addItem(NSMenuItem(title: "💡 Light", action: #selector(Document().setColorLight), keyEquivalent: "L"))
        windowMenu.addItem(NSMenuItem(title: "🌚 Dark", action: #selector(Document().setColorDark), keyEquivalent: "N"))
        windowMenu.addItem(NSMenuItem(title: "📟 Toggle Word & Char Counter", action: #selector(Document().toggleCounters), keyEquivalent: ""))
        shareMenu.addItem(NSMenuItem(title: "🐦 Tweet", action: #selector(Document().tweetText), keyEquivalent: ""))
        shareMenu.addItem(NSMenuItem(title: "✉️ Mail", action: #selector(Document().emailText), keyEquivalent: ""))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

