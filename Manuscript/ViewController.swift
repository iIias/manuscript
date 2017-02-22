//
//  ViewController.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    var win: NSWindow!
    
        override func viewWillAppear() {
        }
        override func viewDidAppear() {
        }
        
    
    func setLightMode() {
        //: set colors to light
        Document().win.backgroundColor = C.colorLight
        Document().textField.backgroundColor = C.colorLight
        Document().textField.textColor = NSColor.gray
        Document().textField.placeholderAttributedString = NSAttributedString(string: Document().placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
    }
    
    func setDarkMode() {
        //: set colors to dark
        Document().win.backgroundColor = NSColor.black
        Document().textField.backgroundColor = NSColor.black
        Document().textField.textColor = C.colorLight
        Document().textField.placeholderAttributedString = NSAttributedString(string: Document().placeholder, attributes: [NSForegroundColorAttributeName: NSColor.lightGray ,NSFontAttributeName: C.font!])
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    
    func textDidChange(notificationCenter: NSNotification) {
        print("test")
    }
    
}
