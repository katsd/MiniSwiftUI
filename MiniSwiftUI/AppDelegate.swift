//
//  AppDelegate.swift
//  DeclUI
//
//  Created by Katsu Matsuda on 2022/06/18.
//
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let rect = NSRect(x: 0, y: 0, width: 480, height: 270)
        window = NSWindow(
            contentRect: rect,
            styleMask: [.miniaturizable, .closable, .resizable, .titled],
            backing: .buffered,
            defer: false)
        window.center()
        window.title = "View"
        //window.contentView = Renderer(content: SlideView(), frame: rect)
        window.contentView = Renderer(content: Counter(), frame: rect)
        window.makeKeyAndOrderFront(nil)
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}
