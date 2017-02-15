//
//  ViewController.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 07/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
    
    @IBOutlet var textView: NSView!
    var win: NSWindow!
    var document: Document!
    var placeholder: String = "Insert random quote here"
    var textField = NSTextField()
         override func viewWillAppear() {
            //: NSWindow setup
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
            textField.placeholderString = placeholder
            textField.focusRingType = .none
            win.isOpaque = false
            //: check if macOS is in dark mode or not
            let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
            if appearance == "Dark" {
                setDarkMode()
            } else {
                setLightMode()
            }
        }
    
    func setLightMode() {
        //: set colors to light
        win.backgroundColor = C.editorBackground
        textField.backgroundColor = C.editorBackground
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
    }
    
    func setDarkMode() {
        //: set colors to dark
        win.backgroundColor = C.colorDark
        textField.backgroundColor = C.colorDark
        textField.textColor = C.colorLight
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: C.colorLight,NSFontAttributeName: C.font!])
    }
    
    func saveTextToDocuments() {
        // Take textField.stringValue, encode & save to file
        let filename = "manuscript.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let path: URL = dir.appendingPathComponent(filename)
        let str: String = textField.stringValue
        do {
            try str.write(to: path, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("failed to write file")
        }  }  }
    
    func saveTextToDesktop() {
        // Take textField.stringValue, encode & save to file
        let filename = "manuscript.txt"
        if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
            let path: URL = dir.appendingPathComponent(filename)
            let str: String = textField.stringValue
            do {
                try str.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print("failed to write file")
            }  }  }
    
        override func viewDidAppear() {
        }
 
        override func viewDidLoad() {
            super.viewDidLoad()
            textField.becomeFirstResponder()
        }
    
        
}

