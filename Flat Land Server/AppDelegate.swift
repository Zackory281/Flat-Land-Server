//
//  AppDelegate.swift
//  Flat Land Server
//
//  Created by Zackory Cramer on 6/20/18.
//  Copyright © 2018 Zackory Cui. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do{
            if let arenaViewController = NSApplication.shared.mainWindow?.contentViewController as? ArenaViewController {
                let modelController = try ArenaModelController(size: CGSize(width: 900, height: 900))
                arenaViewController.gameModelController = modelController
                arenaViewController.presentScene()
                modelController!.startServer()
            }
        }catch{
            print("failed to initiate model controller : \(error)")
        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
