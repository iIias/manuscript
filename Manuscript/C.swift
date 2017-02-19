//
//  C.swift
//  Manuscript
//
//  Created by Ilias Ennmouri on 14/01/2017.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Cocoa

class C: NSObject {
    static let editorBackground: NSColor = NSColor(red:0.255, green:255, blue:0.255, alpha:0.96)
    static let editorTextColor: NSColor = NSColor(red:0.349, green:0.349, blue:0.314, alpha:1)
    static let canvasColor: NSColor = NSColor(red:0.349, green:0.349, blue:0.314, alpha:0.95)
    static let titleFont = NSFont(name: "Avenir-Heavy", size: 20)
    static let font = NSFont(name: "Avenir-Medium", size: 17)
    static let colorLight = NSColor(red:0.255, green:255, blue:0.255, alpha:0.96)
    static let colorDark = NSColor(red:0.1, green:0.1, blue:0.1, alpha:0.95)
    static let colorGray = NSColor(red:0.220, green:0.220, blue:0.220, alpha:1)

    static let editorAtts:[String:AnyObject] = [
        NSFontNameAttribute : C.font!,
        NSForegroundColorAttributeName : C.editorTextColor,
        NSBackgroundColorAttributeName : C.editorBackground,
    ]    
}
