//
//  StatusBarController.swift
//  PreForget
//
//  Created by Anson Goo on 4/9/23.
//

import AppKit
import SwiftUI

class StatusBarController{
    
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private(set) var popover: NSPopover

    var menu = NSMenu()
    init(_ popover: NSPopover){
        
        self.popover = popover
        statusBar = .init()
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button{
            button.image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: "")
            button.action = #selector(self.clickManager(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }
        
    }

    @objc func clickManager(sender: NSStatusItem) {

        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            // Right button click
            let statusBarMenu = NSMenu()
            
            let about = (NSMenuItem(title:"About PreForget", action:#selector(self.about(sender:)),keyEquivalent: "a"))
            about.target = self
            statusBarMenu.addItem(about)
            statusBarMenu.addItem(.separator())
            
            statusBarMenu.addItem(NSMenuItem(title:"Quit", action:#selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
                statusItem.menu = statusBarMenu
                statusItem.button?.performClick(nil)
                statusItem.menu = nil
        }else if event.type == NSEvent.EventType.leftMouseUp{
            
            if popover.isShown{
//                statusItem.button!.image = image
                popover.performClose(nil)
            }else{
//                statusItem.button!.image = coloredImage
                popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: NSRectEdge.maxY)
            }
        }
    }
    
    @objc func about(sender: NSMenuItem){
            let aboutView = aboutView()
            let hostingController = NSHostingController(rootView: aboutView.frame(width: 350, height: 380))
            let window = NSWindow(contentViewController: hostingController)
            
            window.setContentSize(NSSize(width: 350, height: 380))
            window.center()
            
            window.title = "About"
            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
    }
}
extension NSImage {
    func tint(color: NSColor) -> NSImage {
        return NSImage(size: size, flipped: false) { (rect) -> Bool in
            color.set()
            rect.fill()
            self.draw(in: rect, from: NSRect(origin: .zero, size: self.size), operation: .destinationIn, fraction: 1.0)
            return true
        }
    }
}
