//
//  C.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 14/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class C: NSObject {
    static let editorTextColor: NSColor = NSColor(red:0.349, green:0.349, blue:0.314, alpha:1)
    static let canvasColor: NSColor = NSColor(red:0.349, green:0.349, blue:0.314, alpha:0.95)
    static let titleFont = NSFont(name: "Avenir-Heavy", size: 19)
    static let font = NSFont(name: "OpenSans", size: 17)
    static let colorLight = NSColor(red:0.255, green:255, blue:0.255, alpha:0.96)
    static let colorDark = NSColor(red:0.1, green:0.1, blue:0.1, alpha:0.97)
    static let transparent = NSColor(red:0.1, green:0.1, blue:0.1, alpha:0.00)
    
    static let editorAtts:[String:AnyObject] = [
        NSFontNameAttribute : C.font!,
        NSForegroundColorAttributeName : C.editorTextColor,
    ]
}
