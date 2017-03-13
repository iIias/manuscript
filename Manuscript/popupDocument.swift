//
//  popupDocument.swift
//  Manuscript++
//
//  Created by Ilias Ennmouri on 13.03.17.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa
import Emoji
import CloudKit

class popupDocument: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var counterLabel: NSTextField!
    
    
    var wordCount: Int = 0
    var characterCount: Int = 0
    var readtime: Int = 0
    var readtimeString: String = "< 1 min"
    
    let record = CKRecord(recordType: "Text")
    let defaultContainer = CKContainer.default()
    
    @IBAction func shareButton(_ sender: Any) {
        Document().mailText(text: textView.string!)
    }
    @IBAction func saveButton(_ sender: Any) {
        let privateDB = defaultContainer.privateCloudDatabase
        record["StringField"] = textView.string! as CKRecordValue?
        privateDB.save(record) { (record, error) -> Void in
            guard let record = record else {
                print("Error saving record: ", error ?? String())
                return
            }
            print("Successfully saved record: ", record)
        }
    }
    @IBAction func toggleCounterButton(_ sender: Any) {
        if counterLabel.isHidden == true {
            counterLabel.isHidden = false
        } else if counterLabel.isHidden == false {
                counterLabel.isHidden = true
            }
        }
    
    @IBAction func smallerText(_ sender: Any) {
        let newSize = textView.font!.pointSize - CGFloat(2)
        textView.font = NSFont(name: (textView.font?.fontName)!, size: newSize)
    }
    @IBAction func biggerText(_ sender: Any) {
        let newSize = textView.font!.pointSize + CGFloat(2)
        textView.font = NSFont(name: (textView.font?.fontName)!, size: newSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        textView.delegate = self
        textView.font = C.font
        textView.backgroundColor = C.transparent
        scrollView.verticalScroller = .none
        counterLabel.stringValue = "🔠 \(characterCount)     🕐 \(readtimeString)"
        
    }
    
    func textDidChange(_ notification: Notification) {
        updateCounter()
        textView.string! = textView.string!.emojiUnescapedString
        if let piRange = textView.string!.range(of: "*pi*") {
            textView.string!.replaceSubrange(piRange, with: "3.14159265359")
        }
        if let countersRange = textView.string!.range(of: "/toggle-counters") {
            textView.string!.replaceSubrange(countersRange, with: "")
        }
        if let twitterRange = textView.string!.range(of: "/send-tweet") {
            textView.string!.replaceSubrange(twitterRange, with: "")
            Document().tweetText(text: textView.string!)
        }
        if let mailRange = textView.string!.range(of: "/send-mail") {
            textView.string!.replaceSubrange(mailRange, with: "")
            Document().mailText(text: textView.string!)
        }
        if let quitRange = textView.string!.range(of: "/quit") {
            textView.string!.replaceSubrange(quitRange, with: "")
            NSApplication.shared().terminate(self)
        }
        if let encipherRange = textView.string!.range(of: "/encipher") {
            textView.string!.replaceSubrange(encipherRange, with: "")
            offSetAlert(msgTxt: "Think of a number to encipher the text.\n (You will need this number again to decipher the text)", bttnTtl: "Encipher 🔐")
        }
        if let decipherRange = textView.string!.range(of: "/decipher") {
            textView.string!.replaceSubrange(decipherRange, with: "")
            offSetAlert(msgTxt: "To decipher the text you need to enter the number you used to encipher it", bttnTtl: "Decipher 🔓")
        }
        if let saveRange = textView.string!.range(of: "/save") {
            textView.string!.replaceSubrange(saveRange, with: "")
        }
        if let helpRange = textView.string!.range(of: "/help") {
            textView.string!.replaceSubrange(helpRange, with: "")
            Document().commandsAlert()
        }
    }
    
    func updateCounter() {
        wordCount = (textView.string!.characters.filter { $0 == " " }.count) + 1
        characterCount = textView.string!.characters.count
        if wordCount < 80 {
            readtimeString = "< 1 min"
        } else {
            readtime = wordCount / 80
            readtimeString = "\(readtime) min"
        }
        counterLabel.stringValue = "🔠 \(characterCount)     🕐 \(readtimeString)"
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
                let encipheredText = encipher(offset: Int(offsetField.stringValue)!, message: textView.string!)
                textView.string! = encipheredText
            } else if msgTxt == "To decipher the text you need to enter the number you used to encipher it" {
                let decipheredText = decipher(offset: Int(offsetField.stringValue)!, message: textView.string!)
                textView.string! = decipheredText
            }
        }
    }
}
