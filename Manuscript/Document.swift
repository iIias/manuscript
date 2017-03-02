//
//  Document.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 21.02.17.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    @IBOutlet var win: NSWindow!
    @IBOutlet weak var textField: NSTextField!
    var contents: String = ""
    var placeholderList: Array = ["Dream big, do much bigger 💪", "If you can dream it, you can do it 👨‍🚀", "Writing is the painting for the voice 👩‍🎨", "It is uncomfortable to bear an untold story inside you ✍️"]
    var placeholder: String = ""
    let randomInt: Int = Int(arc4random_uniform(4))
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        if #available(OSX 10.12.2, *) {
            textField.allowsCharacterPickerTouchBarItem = true
        } else {
            // Fallback on earlier versions
        }
        placeholder = placeholderList[randomInt]
        super.windowControllerDidLoadNib(aController)
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        win.backgroundColor = C.colorLight
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.isEditable = true
        textField.focusRingType = .none
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
        win.isOpaque = false
        textField.stringValue = contents as String
        // Check whether macOS is set to dark or light
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"; dump("Manuscript appearance set to \(appearance) 🌇")
        if appearance == "Dark" {
            //: set colors to dark
            setColorDark()
        } else {
            //: set colors to light
            setColorLight()
        }
    }
    
    func setColorDark() {
        self.win.backgroundColor = NSColor.black
        self.textField.backgroundColor = NSColor.black
        self.textField.textColor = C.colorLight
        self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.lightGray ,NSFontAttributeName: C.font!])
    }
    
    func setColorLight() {
        self.win.backgroundColor = C.colorLight
        self.textField.backgroundColor = C.colorLight
        self.textField.textColor = NSColor.gray
        self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
    }
    
    func toggleTitlebar() {
        if win.titlebarAppearsTransparent == true {
            win.titlebarAppearsTransparent = false
        } else {
            win.titlebarAppearsTransparent = true
        }
    }
    
    override func data(ofType typeName: String) throws -> Data {
        // Return stringValue & encode using utf8 encoding
        return textField.stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        if data.count > 0 {
            self.contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String!
        }
        
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
}
