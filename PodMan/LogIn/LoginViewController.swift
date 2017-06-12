//
//  ViewController.swift
//  PodMan
//
//  Created by 万圣 on 2017/5/18.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa
//import OAuth2

let OAuth2AppDidReceiveCallbackNotification = NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback")

class LoginViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRedirect(_:)), name: OAuth2AppDidReceiveCallbackNotification, object: nil)
        if loader.oauth2.accessToken != nil {
            loginAnimation(true)
            self.OAuthorWithGitHub()
        }
    }

//MARK: ---- privateMethod
    @objc fileprivate final func handleRedirect(_ notification: Notification) {
        
        if let url = notification.object as? URL {
            loginStatusLabel.stringValue = "获取授权中..."
            do {
                try loader.oauth2.handleRedirectURL(url)
                self.OAuthorWithGitHub()
            }
            catch let error {
                show(error)
            }
        }
        else {
            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid notification: did not contain a URL"]))
        }
    }
    
    /** Forwards to `display(error:)`. */
    fileprivate func show(_ error: Error) {
        if let error = error as? OAuth2Error {
            let err = NSError(domain: "OAuth2ErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: error.description])
            display(err)
        }
        else {
            display(error as NSError)
        }
    }
    
    /** Alert or log the given NSError. */
    fileprivate func display(_ error: NSError) {
        if let window = self.view.window {
            NSAlert(error: error).beginSheetModal(for: window, completionHandler: nil)
        }
        else {
            NSLog("Error authorizing: \(error.description)")
        }
    }
    
    fileprivate final func loginAnimation(_ loging:Bool){
        loginStatusLabel.stringValue = loging ? "登录中..." : "登录失败"
        loginBtn.isHidden = loging
        loginIndicator.isHidden = !loging
        loging ? loginIndicator.startAnimation(nil) : loginIndicator.stopAnimation(nil)
    }
    
    fileprivate final func gotoMainVC(iconURL:String){
        
        self.iconURL = iconURL
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init("gotoMain"), sender: nil)
        
    }
    

//MARK: ---- eventResponse
    @IBAction func loginBtnClicked(_ sender: Any) {
        loginAnimation(true)
        loader.oauth2.authorize { (json, error) in
            if let error = error{
                self.show(error)
            }
        }
    }
    
    @IBAction func skipLoginClicked(_ sender: Any) {
        self.gotoMainVC(iconURL: "")
    }
    
//MARK: ---- netWork
    fileprivate final func OAuthorWithGitHub(){
        GitHubLoader.init().requestUserdata { (dict, error) in
            if let error = error {
                self.loginAnimation(false)
                switch error {
                case OAuth2Error.requestCancelled: break
                default:
                    self.show(error)
                }
            }
            else {
                if let imgURL = dict?["avatar_url"] as? String {
                    self.gotoMainVC(iconURL: imgURL)
                }
                else {
                    self.loginAnimation(false)
                }
                
            }
        }
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier!.rawValue == "gotoMain" {
            superWindow?.close()
            let windowVC = segue.destinationController as! NSWindowController
            let vc:MainContentViewController = windowVC.contentViewController as! MainContentViewController
            vc.iconURL = iconURL ?? ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
//MARK: ---- getter && setter
    var loader: DataLoader = GitHubLoader.init()
    fileprivate var iconURL:String?
    fileprivate var name:String?
    
    
    var superWindow:NSWindowController?
    
    @IBOutlet weak var loginStatusLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var loginBtn: NSButton!
    @IBOutlet weak var loginIndicator: NSProgressIndicator!
}

