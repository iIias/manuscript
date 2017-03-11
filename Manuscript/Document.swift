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
import Emoji

class Document: NSDocument, NSTextViewDelegate {
    
    @IBOutlet var win: NSWindow!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textField: NSTextView!
    @IBOutlet weak var wordCountLabel: NSTextField!
    @IBOutlet weak var characterCountLabel: NSTextField!
    
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
        
        textField.string = contents as String
        
        setColorLight()
        
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
        textField.string! = textField.string!.emojiUnescapedString
        if let piRange = textField.string!.range(of: "*pi*") {
            textField.string!.replaceSubrange(piRange, with: "3.14159265359")
        }
        if let darkRange = textField.string!.range(of: "/dark-mode") {
            setColorDark()
            textField.string!.replaceSubrange(darkRange, with: "")
        }
        if let lightRange = textField.string!.range(of: "/light-mode") {
            setColorLight()
            textField.string!.replaceSubrange(lightRange, with: "")
        }
        if let titlebarRange = textField.string!.range(of: "/toggle-titlebar") {
            toggleTitlebar()
            textField.string!.replaceSubrange(titlebarRange, with: "")
        }
        if let titleRange = textField.string!.range(of: "/toggle-title") {
            textField.string!.replaceSubrange(titleRange, with: "")
            toggleTitle()
        }
        if let countersRange = textField.string!.range(of: "/toggle-counters") {
            toggleCounters()
            textField.string!.replaceSubrange(countersRange, with: "")
        }
        if let twitterRange = textField.string!.range(of: "/send-tweet") {
            textField.string!.replaceSubrange(twitterRange, with: "")
            tweetText()
        }
        if let mailRange = textField.string!.range(of: "/send-mail") {
            textField.string!.replaceSubrange(mailRange, with: "")
            mailText()
        }
        if let quitRange = textField.string!.range(of: "/quit") {
         textField.string!.replaceSubrange(quitRange, with: "")
            NSApplication.shared().terminate(self)
        }
        if let encipherRange = textField.string!.range(of: "/encipher") {
        textField.string!.replaceSubrange(encipherRange, with: "")
            offSetAlert(msgTxt: "Think of a number to encipher the text.\n (You will need this number again to decipher the text)", bttnTtl: "Encipher 🔐")
        }
        if let decipherRange = textField.string!.range(of: "/decipher") {
            textField.string!.replaceSubrange(decipherRange, with: "")
            offSetAlert(msgTxt: "To decipher the text you need to enter the number you used to encipher it", bttnTtl: "Decipher 🔓")
        }
        if let helpRange = textField.string!.range(of: "/help") {
            textField.string!.replaceSubrange(helpRange, with: "")
            commandsAlert()
        }
   }
    
    func commandsAlert() {
        let alert = NSAlert()
        alert.messageText = "All the commands 📟"
        alert.informativeText = "/quit - terminate the app\n/dark-mode - set style to dark\n/light-mode - set style to light\n/toggle-titlebar - toggle titlebar shown/hidden\n/toggle-title - toggle title shown/hidden\n/toggle-counters - toggle word/char counters\n/send-tweet - share your text on twitter\n/send-mail - share your text per mail\n/encipher - encipher your text\n/decipher - decipher your text"
        alert.addButton(withTitle: "Got it!")
        alert.runModal()
    }
    
    func offSetAlert(msgTxt: String, bttnTtl: String) {
        let alert = NSAlert()
        alert.messageText = msgTxt
        alert.addButton(withTitle: bttnTtl)
        alert.addButton(withTitle: "Cancel")
        
        let offsetField = NSTextField(frame: CGRect(x: 50, y: 50, width: 200, height: 20))
        offsetField.placeholderString = "eg. 21"
        alert.accessoryView = offsetField
        
        let buttonPressed = alert.runModal()
        
        if buttonPressed == NSAlertFirstButtonReturn {
            if msgTxt == "Think of a number to encipher the text.\n (You will need this number again to decipher the text)" {
                let encipheredText = encipher(offset: Int(offsetField.stringValue)!, message: textField.string!)
                textField.string! = encipheredText
            } else if msgTxt == "To decipher the text you need to enter the number you used to encipher it" {
                let decipheredText = decipher(offset: Int(offsetField.stringValue)!, message: textField.string!)
                textField.string! = decipheredText
            }
        }
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
    
    func mailText() {
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
        self.characterCountLabel.textColor = C.colorLight
        self.wordCountLabel.textColor = C.colorLight
        self.textField.font = C.font
        self.textField.insertionPointColor = NSColor.white
    }
    
    func setColorLight() {
        self.win.backgroundColor = C.colorLight
        self.textField.backgroundColor = C.colorLight
        self.textField.textColor = NSColor.darkGray
        self.textField.textColor = NSColor.darkGray
        self.characterCountLabel.textColor = NSColor.darkGray
        self.wordCountLabel.textColor = NSColor.darkGray
        self.textField.font = C.font
        self.textField.insertionPointColor = NSColor.darkGray
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
    
    func toggleTitle() {
        if win.titleVisibility == .hidden {
            AppDelegate().ud.set("titleShown", forKey: "manuscriptTitle")
            win.titleVisibility = .visible
        } else if win.titleVisibility == .visible {
            AppDelegate().ud.set("titleShown", forKey: "manuscriptTitle")
            win.titleVisibility = .hidden
        }
    }
    
    func toggleTitlebar() {
        if win.titlebarAppearsTransparent == true {
            AppDelegate().ud.set("titlebarShown", forKey: "manuscriptTitlebar")
            win.titlebarAppearsTransparent = false
        } else if win.titlebarAppearsTransparent == false{
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
