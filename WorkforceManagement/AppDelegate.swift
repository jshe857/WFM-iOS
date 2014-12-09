//
//  AppDelegate.swift
//  WorkforceManagement
//
//  Created by Jeffrey Shen on 9/10/2014.
//  Contact jeshen@au1.ibm.com for more information
//  Copyright (c) 2014 IBM. All rights reserved.
//


//  WFM Native iOS app
//
//
//  Flow
//  1.downloads a csv file from sydgsa server (EmployeeListProvider.swift)
//  2.parses and stores the data into a local sqlite3 db using 3rd party
//  opensource FMDB wrapper functions(CSV.swift)
//  3.displays data into a table view(MasterViewController.swift)
//  4.displays detail view on cell tap (DetailViewController.swift)
//
//  Features
//  App contains filter functionality
//  filter screen interacts with sqldb to filter on given criteria (FilterViewController.swift)





import UIKit
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var collapseDetailViewController = true
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            
            return false
    }


}

