//
//  AppDelegate.swift
//  Example
//
//  Created by Grizzly on 31.01.17.
//  Copyright © 2017 Grizzly New Technologies GmbH. All rights reserved.
//

import UIKit
import AppRating

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        
        // first set the appID - this must be the very first call of AppRating!
        AppRating.appID("990581954");
        
        // enable debug mode (disable this in production mode)
        AppRating.debugEnabled(true);
        
        // reset the counters (for testing only);
        // AppRating.resetAllCounters();
        
        // set some of the settings (see the github readme for more information about that)
        AppRating.daysUntilPrompt(0);
        AppRating.usesUntilPrompt(2);
        AppRating.significantEventsUntilPrompt(0); // set this to zero if you dont't want to use this feature
        
        
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

