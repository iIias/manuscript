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
import WebKit

class Document: NSDocument, NSTextViewDelegate {
    
    @IBOutlet var win: NSWindow!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textField: NSTextView!
    @IBOutlet weak var characterCountLabel: NSTextField!
    
    var contents: String = ""
    var characterCount = 0
    var wordCount = 0
    var readtime = 0
    var readtimeString = ""
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        textField.delegate = self
        
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        scrollView.verticalScroller = .none
        
        if AppDelegate().ud.string(forKey: "manuscriptStyle") == "dark" {
            setColorDark()
        } else if AppDelegate().ud.string(forKey: "manuscriptStyle") == "light" {
            setColorLight()
        }
        
        if AppDelegate().ud.string(forKey: "manuscriptToolbar") == "toolbarHidden" {
            characterCountLabel.isHidden = true
        } else if AppDelegate().ud.string(forKey: "manuscriptToolbar") == "toolbarShown" {
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
//        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"; dump("Manuscript appearance set to \(appearance) 🌇")
//        if appearance == "Dark" {
//            //: set colors to dark
//            setColorDark()
//        } else {
//            //: set colors to light
//            setColorLight()
//        }
    }
    
    

    func textDidChange(_ notification: Notification) {
        updateCounter()
        textField.string! = textField.string!.emojiUnescapedString
        if let piRange = textField.string!.range(of: "*pi*") {
            textField.string!.replaceSubrange(piRange, with: "3.14159265359")
        }
        if let darkRange = textField.string!.range(of: "/dark") {
            textField.string!.replaceSubrange(darkRange, with: "")
            setColorDark()
        }
        if let lightRange = textField.string!.range(of: "/light") {
            textField.string!.replaceSubrange(lightRange, with: "")
            setColorLight()
        }
        if let titlebarRange = textField.string!.range(of: "/toggle-titlebar") {
            toggleTitlebar()
            textField.string!.replaceSubrange(titlebarRange, with: "")
        }
        if let countersRange = textField.string!.range(of: "/toggle-counters") {
            toggleCounters()
            textField.string!.replaceSubrange(countersRange, with: "")
        }
        if let twitterRange = textField.string!.range(of: "/send-tweet") {
            textField.string!.replaceSubrange(twitterRange, with: "")
            tweetText(text: textField.string!)
        }
        if let mailRange = textField.string!.range(of: "/send-mail") {
            textField.string!.replaceSubrange(mailRange, with: "")
            mailText(text: textField.string!)
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
        if let saveRange = textField.string!.range(of: "/save") {
            textField.string!.replaceSubrange(saveRange, with: "")
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
    
    func tweetText(text: String) {
        if text.characters.count < 140 {
            let linkText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let url = NSURL(string: "http://twitter.com/home?status=\(linkText)")
            NSWorkspace.shared().open(url as! URL)
        } else {
            _ = dialogOK(question: "We're sorry, your Tweet is too long 😔", text: "Twitter only supports 140 characters per tweet by now.")
        }
    }
    
    func mailText(text: String) {
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)!
        service.perform(withItems: [text])
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
        if wordCount < 80 {
            readtimeString = "< 1 min"
        } else {
            readtime = wordCount / 80
            readtimeString = "\(readtime) min"
        }
        characterCountLabel.stringValue = "🔠 \(characterCount)     🕐 \(readtimeString)"
    }
    
    func setColorDark() {
        AppDelegate().ud.set("dark", forKey: "manuscriptStyle")
        self.win.backgroundColor = NSColor.black
        self.textField.backgroundColor = NSColor.black
        self.textField.textColor = C.colorLight
        self.characterCountLabel.textColor = C.colorLight
        self.textField.font = C.font
        self.textField.insertionPointColor = NSColor.white
    }
    
    func setColorLight() {
        AppDelegate().ud.set("light", forKey: "manuscriptStyle")
        self.win.backgroundColor = C.colorLight
        self.textField.backgroundColor = C.colorLight
        self.textField.textColor = NSColor.darkGray
        self.textField.textColor = NSColor.darkGray
        
        self.characterCountLabel.textColor = NSColor.darkGray
        self.textField.font = C.font
        self.textField.insertionPointColor = NSColor.darkGray
    }
    
    func toggleCounters() {
        if characterCountLabel.isHidden {
            AppDelegate().ud.set("toolbarShown", forKey: "manuscriptToolbar")
            characterCountLabel.isHidden = false
        } else {
            AppDelegate().ud.set("toolbarHidden", forKey: "manuscriptToolbar")
            characterCountLabel.isHidden = true
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
