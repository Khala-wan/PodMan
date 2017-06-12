//
//  AppDelegate.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
//import OAuth2
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    public var statusBarItem:NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        
        //MARK:statusBar
        statusBarItem = NSStatusBar.system.statusItem(withLength: 32)
        statusBarItem?.image = NSImage.init(named: NSImage.Name(rawValue: "statusBarIcon"))
        statusBarItem?.menu = StatusBarMenu.loadWithNibName("StatusBarMenu", StatusBarMenu.classForCoder())
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        saveContext()
        NSStatusBar.system.removeStatusItem(statusBarItem!)
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    /** Gets called when the App launches/opens via URL. */
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
            let url = URL(string: urlString)!
            if "podman" == url.scheme && "oauth" == url.host {
                NotificationCenter.default.post(name: OAuth2AppDidReceiveCallbackNotification, object: url)
            }
        }
        else {
            NSLog("No valid URL to handle")
        }
    }
    
//MARK: ---- Core Data
    //持久化存储协调器
    public lazy var persistentContainer:NSPersistentContainer = {
        let contatiner = NSPersistentContainer(name:"PodManCoreData")
        contatiner.loadPersistentStores(completionHandler: { (store, error) in
            if let error = error as NSError?{
                fatalError("发生错误:\(error),\(error.userInfo)")
            }
        })
        return contatiner
    }()
    
    //保存数据上下文
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("发生错误:\(error),\(error.userInfo)")
            }
        }
    }
}

