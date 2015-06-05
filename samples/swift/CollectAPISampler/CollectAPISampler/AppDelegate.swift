//
//  AppDelegate.swift
//  CollectAPISampler
//
//  Created by George Webster on 6/4/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let configuration = TEALCollectConfiguration(account: "tealiummobile", profile: "demo", environment: "dev")
        
        configuration.logLevel = TEALConnectLogLevel.Verbose
        
        TealiumCollect.enableWithConfiguration(configuration)
        
        sendLifecycleEventWithName("m_launch")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        sendLifecycleEventWithName("m_sleep")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
        sendLifecycleEventWithName("m_wake")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    func sendLifecycleEventWithName(name: String) {
        
        let data: [String: String] = ["event_name" : name]
        
        TealiumCollect.sendEventWithData(data)
    }

}

