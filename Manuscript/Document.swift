//
//  Document.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 21.02.17.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa
import WebKit

class Document: NSDocument, NSTextViewDelegate {
    
    @IBOutlet var win: NSWindow!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textField: NSTextView!
    @IBOutlet weak var wordCountLabel: NSTextField!
    @IBOutlet weak var characterCountLabel: NSTextField!
    @IBOutlet weak var webView: WKWebView!
    
    var markdown: Markdown?
    
    var contents: String = ""
    var wordCount = 0
    var characterCount = 0
    
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        textField.delegate = self
        
        let noti = NotificationCenter.default
        noti.addObserver(self, selector: #selector(NSTextDelegate.textDidChange(_:)), name: NSNotification.Name.NSControlTextDidChange, object: textField)
        
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        scrollView.verticalScroller = .none
        
        if AppDelegate().ud.string(forKey: "manuscriptCounters") == "countersHidden" {
            wordCountLabel.isHidden = true
            characterCountLabel.isHidden = true
        } else if AppDelegate().ud.string(forKey: "manuscriptCounters") == "countersShown" {
            wordCountLabel.isHidden = false
            characterCountLabel.isHidden = false
        }
        
        if AppDelegate().ud.string(forKey: "manuscriptTitlebar") == "titlebarHidden" {
            win.titlebarAppearsTransparent = true
        } else if AppDelegate().ud.string(forKey: "manuscriptCounters") == "titlebarShown" {
            win.titlebarAppearsTransparent = false
        }
        
        setColorLight()
        
        textField.string = contents as String
        
        updateCounter()
        
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
        updateCounter()
   }
    

    func tweetText() {
        if (textField.string?.characters.count)! < 140 {
            let linkText = textField.string!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let url = NSURL(string: "http://twitter.com/home?status=\(linkText)")
            NSWorkspace.shared().open(url as! URL)
        } else {
            _ = dialogOK(question: "We're sorry, your Tweet is too long 😔", text: "Twitter only supports 140 characters per tweet by now.")
        }
    }
    
    func emailText() {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
        service.perform(withItems: [textField.string!])
    }
    
    func dialogOK(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    func updateCounter() {
        wordCount = (textField.string!.characters.filter { $0 == " " }.count) + 1
        characterCount = textField.string!.characters.count
        wordCountLabel.stringValue = "Words: \(wordCount)"
        characterCountLabel.stringValue = "Characters: \(characterCount)"
    }
    
    func setColorDark() {
        self.win.backgroundColor = NSColor.black
        self.textField.backgroundColor = NSColor.black
        self.textField.textColor = C.colorLight
    }
    
    func setColorLight() {
        self.win.backgroundColor = C.colorLight
        self.textField.backgroundColor = C.colorLight
        self.textField.textColor = NSColor.darkGray
        self.textField.font = C.font
    }
    
    func toggleCounters() {
        if wordCountLabel.isHidden {
            AppDelegate().ud.set("countersShown", forKey: "manuscriptCounters")
            wordCountLabel.isHidden = false
            characterCountLabel.isHidden = false
        } else {
            AppDelegate().ud.set("countersHidden", forKey: "manuscriptCounters")
            wordCountLabel.isHidden = true
            characterCountLabel.isHidden = true
        }
    }
    
    func toggleTitlebar() {
        if win.titlebarAppearsTransparent == true {
            AppDelegate().ud.set("titlebarShown", forKey: "manuscriptTitlebar")
            win.titlebarAppearsTransparent = false
        } else {
            AppDelegate().ud.set("titlebarHidden", forKey: "manuscriptTitlebar")
            win.titlebarAppearsTransparent = true
        }
    }
    
    override func data(ofType typeName: String) throws -> Data {
        // Return stringValue & encode using utf8 encoding
        return textField.string!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        if data.isEmpty { var _ = Document() } else {
            self.contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String!
        }
        
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
}
