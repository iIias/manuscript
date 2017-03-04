//
//  Document.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 21.02.17.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

class Document: NSDocument, NSTextViewDelegate, NSTextDelegate {
    
    @IBOutlet var win: NSWindow!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textField: NSTextView!
    var contents: String = ""
    var placeholderList: Array = ["Dream big, do much bigger 💪", "If you can dream it, you can do it 👨‍🚀", "Writing is the painting for the voice 👩‍🎨", "It is uncomfortable to bear an untold story inside you ✍️"]
    var placeholder: String = ""
    let randomInt: Int = Int(arc4random_uniform(4))
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        textField.delegate = self
        let noti = NotificationCenter.default
        noti.addObserver(self, selector: #selector(NSTextDelegate.textDidChange(_:)), name: NSNotification.Name.NSControlTextDidChange, object: textField)
        placeholder = placeholderList[randomInt]
        scrollView.verticalScroller = .none
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        win.backgroundColor = C.colorLight
        textField.font = C.font
        textField.translatesAutoresizingMaskIntoConstraints = true
//        textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
        textField.string = contents as String
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
    
    func textDidChange(_ notification: Notification) {
        var allText: String = textField.string!
        var wordCount = (textField.string?.characters.filter { $0 == " " }.count)! + 1
        if (textField.string?.contains("#"))! {
              }
    }

    func tweetText() {
        if (textField.string?.characters.count)! < 140 {
            let text: String = textField.string!
            let linkText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//            let linkText = text.replacingOccurrences(of: " ", with: "%20")
            let url = NSURL(string: "http://twitter.com/home?status=\(linkText)")
            NSWorkspace.shared().open(url as! URL)
        } else {
            // I'm sorry but Jack Dorsey is afraid of text that has more than 140 characters. 😬
            _ = dialogOK(question: "We're sorry, your Tweet is too long 😔", text: "Twitter only supports 140 characters per tweet.")
        }
    }
    
    func dialogOK(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    func setColorDark() {
        self.win.backgroundColor = NSColor.black
        self.textField.backgroundColor = NSColor.black
        self.textField.textColor = C.colorLight
//        self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.lightGray ,NSFontAttributeName: C.font!])
    }
    
    func setColorLight() {
        self.win.backgroundColor = C.colorLight
        self.textField.backgroundColor = C.colorLight
        self.textField.textColor = NSColor.gray
//        self.textField.placeholderAttributedString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSFontAttributeName: C.font!])
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
        return textField.string!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        if data.isEmpty { } else {
            self.contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String!
        }
        
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
}
