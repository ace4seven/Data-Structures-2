//
//  AppDelegate.swift
//  aus_sem_2_juraj_macak
//
//  Created by Juraj Macák on 11/10/18.
//  Copyright © 2018 Juraj Macák. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Zobrazenie pozadania appky")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Will resign active")
    }
    

}

