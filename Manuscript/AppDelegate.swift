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
import CloudKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var fileMenu: NSMenu!
    @IBOutlet weak var editMenu: NSMenu!
    @IBOutlet weak var helpMenu: NSMenu!

    var eventMonitor: EventMonitor?
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let statusMenu = NSMenu()
    let writerPopover = NSPopover()
    
    let ud = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize application
        NSApplication.shared()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.writerPopover.isShown  {
                self.closeWriterPopover(sender: event) } }
        eventMonitor?.start()
        helpMenu.addItem(NSMenuItem.separator())
        helpMenu.addItem(NSMenuItem(title: "👨🏽‍💻 Support Mail", action: #selector(supportMail), keyEquivalent: ""))
        helpMenu.addItem(NSMenuItem(title: "📰 Press Mail", action: #selector(pressMail), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem(title: "New Note ✍️", action: #selector(self.openWriterPopover(sender:)), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem.separator())
        if let button = statusItem.button {
            button.title = "✍️"
            button.action = Selector(("togglePopover:"))
        }
        statusItem.menu = statusMenu
        writerPopover.contentViewController = popupDocument(nibName: "popupDocument", bundle: nil)
        NSApp.activate(ignoringOtherApps: true) }
    
    func addNoteItem(name: String) {
           statusMenu.addItem(NSMenuItem(title: "\(name)", action: #selector(popupDocument.updateCounter), keyEquivalent: ""))
    }
    
    
    func openWriterPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            writerPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start() }     }
    
    func closeWriterPopover(sender: AnyObject?) {
        writerPopover.performClose(sender)
        eventMonitor?.stop() }
    
    func togglePopover(sender: AnyObject?) {
        if writerPopover.isShown {
            closeWriterPopover(sender: sender) } else { openWriterPopover(sender: sender) } }
    
    func supportMail() {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
        let process = ProcessInfo.processInfo
        service.recipients = ["support@manuscript.tools"]
        service.subject = "Support request"
        service.perform(withItems: ["Please don't remove the following lines and write your request below them \n\(process.operatingSystemVersionString)\n\(process.systemUptime)\n ---------->"])
    }
    
    func pressMail() {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
        service.recipients = ["yourfriends@manuscript.tools"]
        service.perform(withItems: [""])
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
