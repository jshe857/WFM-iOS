//
//  AppDelegate.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate{

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let storyboard =  UIStoryboard(name: "Main",bundle: nil)
        if UIDevice.currentDevice().systemVersion.hasPrefix("7.")  && UIDevice.currentDevice().localizedModel.hasPrefix("iPhone"){
            self.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier("ios7") as? UIViewController
//        } else if (UIDevice.currentDevice().systemVersion.hasPrefix("7.") ) {
            
        } else {
            // Override point for customization after application launch.
            self.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier("ios8+") as? UIViewController
            let splitViewController = self.window!.rootViewController as UISplitViewController
            let navigationController = splitViewController.viewControllers[0] as UINavigationController
            //navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
            splitViewController.delegate = self
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

}

