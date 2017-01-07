//
//  ViewController.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var win: NSWindow!
    var document: Document!
    
         override func viewWillAppear() {
            win = self.view.window!
            _ = self.view.window?.windowController
            
            win.titlebarAppearsTransparent = true
            win.isMovableByWindowBackground = true
            win.title = ""
            win.backgroundColor = NSColor(red:0.255, green:255, blue:0.255, alpha:1)

        }
        
        override func viewDidAppear() {
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
        
}

