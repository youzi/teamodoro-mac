//
//  AppDelegate.swift
//  Teamodoro
//
//  Created by Youri Daamen on 11/01/2018.
//  Copyright © 2018 Youri Daamen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:22)
    let calendar = Calendar.current
    
    @objc func nn(n: Int) -> String {
        return n < 10 ? "0\(n)" : "\(n)"
    }
    
    @objc func updateMenuCounter(minutesLeft: Int, secondsLeft: Int, type: String) {
        statusItem.menu?.item(at:0)?.title = "\(type): \(nn(n: minutesLeft)):\(nn(n: secondsLeft))"
    }
    
    @objc func updateStatusCounter(minutesLeft: Int, secondsLeft: Int, appearsDisabled: Bool) {
        statusItem.button?.appearsDisabled = appearsDisabled
        statusItem.button?.title = "\(secondsLeft == 0 ? minutesLeft : minutesLeft + 1)"
    }
    
    @objc func updateCounters() {
        let date = Date()
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let secondsLeft = 59 - seconds
        let count = minutes % 30

        if (count > 24 && count < 30) {
            let minutesLeft = 29 - count
            updateStatusCounter(minutesLeft: minutesLeft, secondsLeft: secondsLeft, appearsDisabled: true)
            updateMenuCounter(minutesLeft: minutesLeft, secondsLeft: secondsLeft, type: "Break")
        } else {
            let minutesLeft = 24 - count
            updateStatusCounter(minutesLeft: minutesLeft, secondsLeft: secondsLeft, appearsDisabled:false)
            updateMenuCounter(minutesLeft: minutesLeft, secondsLeft: secondsLeft, type: "Focus")
        }
    }
    
    @objc func openTeamodoro() {
        NSWorkspace.shared.open(URL(string: "http://www.teamodoro.com/")!)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let timer = Timer.init(timeInterval: 1, target: self,   selector: (#selector(updateCounters)), userInfo: nil, repeats: true)
        
        statusItem.menu = NSMenu()
        statusItem.menu?.addItem(NSMenuItem(title: "", action: nil, keyEquivalent: ""))
        statusItem.menu?.addItem(NSMenuItem(title: "Visit teamodoro.com", action: #selector(openTeamodoro), keyEquivalent: ""))
        statusItem.menu?.addItem(NSMenuItem.separator())
        statusItem.menu?.addItem(NSMenuItem(title: "Quit Teamodoro", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        updateCounters()
        
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

