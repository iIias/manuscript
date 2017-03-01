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
    var placeholderList: Array = ["Dream big, do bigger 💪", "If you can dream it, you can do it 👨‍🚀", "Writing is the painting for the voice 👩‍🎨"]
    
    override var windowNibName: String? {
        // Override returning the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
        return "Document"
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        var placeholder: String
        let randomInt: Int = Int(arc4random_uniform(3))
        placeholder = placeholderList[randomInt]
        super.windowControllerDidLoadNib(aController)
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        win.backgroundColor = C.colorLight
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.isEditable = true
        textField.placeholderString = "Insert random quote"
        textField.focusRingType = .none
        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
        win.isOpaque = false
        //: check whether macOS is in dark mode or nah
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"; dump("Manuscript appearance set to \(appearance) 🌇")
        if appearance == "Dark" {
            //: set colors to dark
            self.win.backgroundColor = NSColor.black
            self.textField.backgroundColor = NSColor.black
            self.textField.textColor = C.colorLight
            self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.lightGray ,NSFontAttributeName: C.font!])
        } else {
            //: set colors to light
            self.win.backgroundColor = C.colorLight
            self.textField.backgroundColor = C.colorLight
            self.textField.textColor = NSColor.gray
            self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
        }
    }
    
    
    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        return textField.stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        if data.count > 0 {
            self.contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        }
    }
    
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
}
