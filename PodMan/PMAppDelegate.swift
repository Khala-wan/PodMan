//
//  AppDelegate.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
import OAuth2
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    /** Gets called when the App launches/opens via URL. */
    func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
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
    
    func applicationWillTerminate(_ aNotification: Notification) {
        saveContext()
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

