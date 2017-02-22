//
//  ViewController.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet var textView: NSView!
    var win: NSWindow!
    var placeholder: String = "Insert random quote here"
    @IBOutlet weak var textField: NSTextField!
    
         override func viewWillAppear() {
            //: NSWindow setup
            win = self.textView.window!
            let winController = self.view.window?.windowController
 //           let document: Document = winController!.document as! Document
            textView.addSubview(textField)
            self.textView.wantsLayer = true
            win.titlebarAppearsTransparent = true
            win.isMovableByWindowBackground = true
            win.titleVisibility = NSWindowTitleVisibility.hidden
            win.backgroundColor = C.colorLight
            textView.layer?.cornerRadius = 10.0
            textField.isEditable = true
            textField.placeholderString = placeholder
            textField.focusRingType = .none
            win.isOpaque = false
            
            //: check whether macOS is in dark mode or nah
            let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
            dump(appearance)
            print("Manuscript has been set to \(appearance) 🔥")
            if appearance == "Dark" {
                setDarkMode()
            } else {
                setLightMode()
            }
            }
    
    func setLightMode() {
        //: set colors to light
        win.backgroundColor = C.colorLight
        textField.backgroundColor = C.colorLight
        textField.textColor = NSColor.gray
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
    }
    
    func setDarkMode() {
        //: set colors to dark
        win.backgroundColor = NSColor.black
        textField.backgroundColor = NSColor.black
        textField.textColor = C.colorLight
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.lightGray ,NSFontAttributeName: C.font!])
    }
        override func viewDidAppear() {
        }
 
        override func viewDidLoad() {
            super.viewDidLoad()
            print("View did load! 🌇")
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(ViewController.textDidChange), name: NSNotification.Name.NSTextDidChange, object:textField)
    }
    
    
    func textDidChange(notificationCenter: NSNotification) {
        print("test")
    }
    
}
