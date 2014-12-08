//
//  LoginViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 8/12/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    var connectionAlert = UIAlertView(title:"Could not reach server", message: "Please check your \n connection and try again.", delegate:nil ,cancelButtonTitle: "OK")
    var invalidAlert = UIAlertView(title:"Invalid Email or Password", message: "Please check your details and try again", delegate:nil ,cancelButtonTitle: "OK")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func login(sender: UIButton) {
        // step 1. check the device
        var idiom = UIDevice.currentDevice().userInterfaceIdiom
        
        // step 2. take a storyboard variable
        var storyBoard:UIStoryboard? = nil
        
        // step 3. load appropriate storyboard file
        if idiom == UIUserInterfaceIdiom.Phone {
            storyBoard = UIStoryboard(name: "iPhone", bundle: nil)
            
        } else {
            storyBoard = UIStoryboard(name:"iPad", bundle:nil)
        }
        
        
        let vc = storyBoard!.instantiateInitialViewController() as UIViewController
        self.presentViewController(vc, animated:true, completion:nil)
        
        //self.window!.rootViewController = storyBoard!.instantiateInitialViewController() as UINavigationController
        
        
        //check if rootview is splitview - not supported on ios 7 iphones
        if let splitViewController = vc as? UISplitViewController {
            
            let navigationController = splitViewController.viewControllers[0] as UINavigationController
            
            if (splitViewController.respondsToSelector(Selector("displayModeButtonItem"))){
                splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            }
            
        }
    }
    
    

}