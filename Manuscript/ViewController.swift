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
    @IBOutlet var textField: NSTextField!
    
         override func viewWillAppear() {
            win = self.view.window!
            _ = self.view.window?.windowController
            
            win.titlebarAppearsTransparent = true
            win.isMovableByWindowBackground = true
            win.title = ""
            win.backgroundColor = C.editorBackground
            textField.isEditable = true
            textField.placeholderString = "Thoughts💤☁️"
            textField.focusRingType = .none
        }
    
    func setLightMode() {
        win.backgroundColor = C.editorBackground
        textField.backgroundColor = C.editorBackground
    }
    
    func setDarkMode() {
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

