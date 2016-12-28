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
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("app did enter background")
        UserDefaults.standard.removeObject(forKey: KeyPlayListId.Selected.rawValue)
        UserDefaults.standard.synchronize()
    }

}

