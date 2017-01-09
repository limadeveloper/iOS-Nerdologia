//
//  AppDelegate.swift
//  Nerdologia
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
        UserDefaults.standard.removeObject(forKey: KeyPlayListId.Selected.rawValue)
        UserDefaults.standard.synchronize()
    }

}

