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
        
        configuration.logLevel = TEALCollectLogLevel.Verbose
        
        // If you only want profile enrichment on request.
        // By default the visitor profile is polled each Send Event/View.
        // configuration.pollingFrequency = TEALProfilePollingFrequency.OnRequest;
        
        TealiumCollect.enableWithConfiguration(configuration)
        
        sendLifecycleEventWithName("mobile_launch")
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        sendLifecycleEventWithName("mobile_sleep")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
        sendLifecycleEventWithName("mobile_wake")
    }

    func sendLifecycleEventWithName(name: String) {
        
        let data: [String: String] = ["event_name" : name]
        
        TealiumCollect.sendEventWithData(data)
    }

}

