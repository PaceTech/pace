//
//  AppDelegate.swift
//  Pace
//
//  Created by Tara Wilson on 7/8/15.
//  Copyright (c) 2015 twil. All rights reserved.
//

import UIKit
import GoogleMaps

let analyticsid = "UA-67794662-1"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var googleAnalyticsTracker: GAITracker?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyA1XSNBmrqi1wfP94xDLQklUY-P4GAnN7M")
        self.window?.makeKeyAndVisible()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.None
        googleAnalyticsTracker = GAI.sharedInstance().trackerWithTrackingId(analyticsid)
        
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if let urlstring = url.absoluteString {
            let urls = urlstring.componentsSeparatedByString("://")
            if urls[0] == "paceapp" {
                if urls.count > 0 {
                    if let num = urls[1].toInt() {
                        let pace = Pace()
                        pace.id = "\(num)"
                        let vc = PaceDetailViewController()
                        vc.paceInfo = pace
                        self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                       
                        
                    }
                }
            }
            
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

