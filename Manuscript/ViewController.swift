//
//  ViewController.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSView!
    var win: NSWindow!
    var textField = NSTextField(frame: NSMakeRect(20,20,410,260))
         override func viewWillAppear() {
            view.addSubview(textField)
            win = self.view.window!
            _ = self.view.window?.windowController
            self.view.wantsLayer = true
            win.titlebarAppearsTransparent = true
            win.isMovableByWindowBackground = true
            win.titleVisibility = NSWindowTitleVisibility.hidden
            win.backgroundColor = C.editorBackground
            view.layer?.cornerRadius = 10.0
            textField.isEditable = true
            textField.placeholderString = "Thoughts💤☁️"
            textField.focusRingType = .none
        }
    
    func setLightMode() {
        win.backgroundColor = C.editorBackground
        textField.backgroundColor = C.editorBackground
    }
    
    func setDarkMode() {
        win.becomeMain()
        win.backgroundColor = C.colorDark
        textField.backgroundColor = C.colorDark
        textField.textColor = C.colorLight
    }
    
        override func viewDidAppear() {
        }
 
        override func viewDidLoad() {
            super.viewDidLoad()
            textField.becomeFirstResponder()
        }
    
        
}

