//
//  AppDelegate.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("app did enter background")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(KeyPlayListId.Selected.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}

