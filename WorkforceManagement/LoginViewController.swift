//
//  LoginViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 8/12/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    var connectionAlert = UIAlertView(title:"Could not reach server", message: "Please check your \n connection and try again.", delegate:nil ,cancelButtonTitle: "OK")
    var invalidAlert = UIAlertView(title:"Invalid Email or Password", message: "Please check your details and try again", delegate:nil ,cancelButtonTitle: "OK")
    
    var selectedField:UITextField?
    
    
    
    var vc: UIViewController?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    let isIPhone = UIDevice.currentDevice().model.hasPrefix("iPhone")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        email.delegate = self
        password.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:", name:UIKeyboardDidShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillHide:", name:UIKeyboardWillHideNotification, object:nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAuthenticated:", name: "UserAuthenticated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userInvalid:", name: "userAuthenticationInvalid", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userValid:", name: "userAuthenticationValid", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "userTimeout:", name: "userAuthenticationSuccess", object: nil)
        
        
        let gesture = UITapGestureRecognizer(target:self, action:"dismissKeyboard:")
        scrollView.addGestureRecognizer(gesture)
        
        //instantiate next storyboard
        
        // take a storyboard variable
        var storyBoard:UIStoryboard? = nil
        
        // step 3. load appropriate storyboard file
        if isIPhone {
            storyBoard = UIStoryboard(name: "iPhone", bundle: nil)
            
        } else {
            storyBoard = UIStoryboard(name:"iPad", bundle:nil)
        }
        
        vc = storyBoard!.instantiateInitialViewController() as? UIViewController
    }
    
    func dismissKeyboard(sender:AnyObject) {
        
        password.resignFirstResponder()
        email.resignFirstResponder()
    
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillShow(sender: NSNotification) {
        let dict = sender.userInfo
        let s = dict?[UIKeyboardFrameEndUserInfoKey] as NSValue
        let kbSize = s.CGRectValue()
        
        //keyboard doesnt hide input on ipad
        if (isIPhone) {
            UIView.animateWithDuration(0.1, animations: {
                self.view.bounds.origin.y = 100
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(0.1, animations: {
            self.view.bounds.origin.y = 0
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

        let employeeListProvider = EmployeeListProvider.sharedInstance()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserAuthenticated", object: self)
        
        /*
        let loginProvider = LoginProvider()
        var loginSuccess: Bool = loginProvider.login(email.text, password: password.text)
        
        // Show activity indicator loading
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 100, UIScreen.mainScreen().bounds.height/2 - 100, 200, 200);
        activityIndicator.backgroundColor = UIColor.darkGrayColor()
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        println("test") */
    }
    
    func userValid(sender: AnyObject) {
        println("user valid")
        //activityIndicator.stopAnimating()
        NSNotificationCenter.defaultCenter().postNotificationName("UserAuthenticated", object: self)
    }
    
    func userInvalid(sender: AnyObject) {
        println("user invalid")
        let alert = UIAlertView()
        alert.title = "Login Error"
        alert.message = "Login was unsucessful"
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        dispatch_async(dispatch_get_main_queue(), {self.invalidAlert.show()})
    }
    
    
    // Set storyboard scence based upon device once loged in
    func userAuthenticated(sender: AnyObject) {
        
        //NSTimer(timeInterval: 1800, target: self, selector: <#Selector#>, userInfo: <#AnyObject?#>, repeats: <#Bool#>)

        
        // step 1. check the device
        let isIPhone = UIDevice.currentDevice().model.hasPrefix("iPhone")
        // step 2. take a storyboard variable
        var storyBoard:UIStoryboard? = nil
        // step 3. load appropriate storyboard file
        if isIPhone {
            storyBoard = UIStoryboard(name: "iPhone", bundle: nil)
        } else {
            storyBoard = UIStoryboard(name:"iPad", bundle:nil)
        }
        
        let vc = storyBoard!.instantiateInitialViewController() as UIViewController
        
        
        //check if rootview is splitview - not supported on ios 7 iphones
        if let splitViewController = vc as? UISplitViewController {
            let navigation = splitViewController.viewControllers[0] as UINavigationController
            //let master = (navigationController?.viewControllers[0] as MasterViewController)
            
            //master.employeeListProvider = employeeListProvider
            
            if (splitViewController.respondsToSelector(Selector("displayModeButtonItem"))){
                splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
           }
        } else {
           ((vc as  UINavigationController).topViewController as MasterViewController).employeeListProvider =  employeeListProvider
        }
        
        //manually transition from login screen
        
        let window = UIApplication.sharedApplication().delegate!.window
 
        UIView.transitionWithView(window!!,
            duration:0.5,
            options:UIViewAnimationOptions.TransitionFlipFromLeft,
            animations:{ window!!.rootViewController = vc },
            completion:nil)
        

    }
    
    func timedOut() {
        let logOut = UIAlertView(title: "Timed Out", message: "You have been logged out", delegate: nil, cancelButtonTitle: "OK")
        dispatch_async(dispatch_get_main_queue(), {logOut.show()})
    }

}