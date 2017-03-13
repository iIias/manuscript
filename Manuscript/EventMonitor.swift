
//
//  EventMonitor.swift
//  Manuscript++
//
//  Created by Ilias Ennmouri on 13.03.17.
//  Copyright © 2017 Ilias Ennmouri. All rights reserved.
//

import Foundation
import Cocoa

public class EventMonitor {
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> ()
    
    public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler }
    deinit { stop() }
    public func start() { monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject? }
    public func stop() { if monitor != nil { NSEvent.removeMonitor(monitor!); monitor = nil } } }
