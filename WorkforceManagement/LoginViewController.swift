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
    
    
    let employeeListProvider = EmployeeListProvider()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set up textfield view
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, email.frame.size.height - 1, email.frame.size.width, 0.7);
        
        let passwordBorder = CALayer()
        passwordBorder.frame = CGRectMake(0.0, email.frame.size.height - 1, email.frame.size.width, 0.7);

        bottomBorder.backgroundColor = UIColor.blackColor().CGColor
        passwordBorder.backgroundColor = UIColor.blackColor().CGColor
        
        email.layer.addSublayer(bottomBorder)
        password.layer.addSublayer(passwordBorder)
        
        
        email.delegate = self
        password.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasShown:", name:UIKeyboardDidShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWasHidden:", name:UIKeyboardWillHideNotification, object:nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAuthenticated:", name: "userAuthenticationSuccess", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userInvalid:", name: "userAuthenticationInvalid", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "userTimeout:", name: "userAuthenticationSuccess", object: nil)


    }
    
    override func touchesBegan(touches:NSSet, withEvent event:UIEvent) {
        let touch = event.allTouches()!.anyObject() as UITouch
        if (touch.view != password && touch.view != email) {
            password.resignFirstResponder()
            email.resignFirstResponder()
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    
//    func hideKeyboard(sender: AnyObject) {
//        selectedField?.resignFirstResponder()
//    }
//
//    func textViewDidBeginEditing(textView:UITextView)
//    {
//        
//        self.animateTextView(true)
//    }
//    
//    func textViewDidEndEditing(textView:UITextView)
//    {
//        self.animateTextView(false)
//    }
//    
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillShow(sender: NSNotification) {
        let dict = sender.userInfo
        let s = dict?[UIKeyboardFrameEndUserInfoKey] as NSValue
        let kbSize = s.CGRectValue()
        
        println("keyboard shown")
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
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
        
        employeeListProvider.login(email.text,password:password.text)
       
    }
    
    
    func userInvalid(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {self.invalidAlert.show()})

    }
    
    
    func userAuthenticated(sender: AnyObject) {
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
        //self.window!.rootViewController = storyBoard!.instantiateInitialViewController() as UINavigationController
        
        
        
        let vc = storyBoard!.instantiateInitialViewController() as UIViewController
        
        var master:MasterViewController?
        
        //check if rootview is splitview - not supported on ios 7 iphones
        if let splitViewController = vc as? UISplitViewController {
            let navigation = splitViewController.viewControllers[0] as UINavigationController
            (navigationController?.topViewController as MasterViewController).employeeListProvider = employeeListProvider
            if (splitViewController.respondsToSelector(Selector("displayModeButtonItem"))){
                splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
            }
        } else {
            ((vc as  UINavigationController).topViewController as MasterViewController).employeeListProvider =  employeeListProvider
        }
        self.presentViewController(vc, animated:true, completion:nil)

    }
    
    

}