//
//  DetailViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {

    //Storyboard labels
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var band: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var jrss: UILabel!
    @IBOutlet weak var manager: UILabel!
    @IBOutlet weak var project: UILabel!
    
    var email:String?
    
    var mailToUrl:NSURL?
    var connectionsUrl:NSURL?
    
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view on storyboard segue
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        let scroll = self.view.subviews[0] as UIScrollView
        scroll.center = CGPointMake(0,-100)
        scroll.contentSize = CGSize(width: self.view.bounds.width,height: self.view.bounds.height)
        scroll.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        if let detail = self.detailItem as? [String:String]{
            self.navigationItem.title = "Details"
            name.text = detail["name"]
            availability.text = detail["availability"]
            jrss.text = detail["jrss"]
            band.text = detail["band"]
            home.text = detail["home"]
            business.text = detail["business"]
            manager.text = detail["manager"]
            project.text = detail["project"]
            
            
            if let serial = detail["serial"] {
                let faceUrl = NSURL(string:"http://faces.tap.ibm.com/api/find/?q=uid:"+serial+"&limit=1")!
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:faceUrl),queue:NSOperationQueue(),
                    completionHandler: {response,data, error in
                        if (error != nil) {
                        } else {
                            var jsonError:NSError?
                           if let json = NSJSONSerialization.JSONObjectWithData(data,options:NSJSONReadingOptions.MutableContainers,error:&jsonError) as? NSArray {
                                self.email = (json[0] as NSDictionary)["email"] as String?
                                self.connectionsUrl =  NSURL(string:"https://w3-connections.ibm.com/profiles/html/profileView.do?email=\(self.email!)")
                                self.mailToUrl = NSURL(string:"mailto:"+self.email!)
                            }
                        }
                })

            }
            let emailBtn = self.view.viewWithTag(1) as UIButton
            emailBtn.addTarget(self, action:"sendEmail:", forControlEvents:UIControlEvents.TouchDown)
            let connections = self.view.viewWithTag(2)
            let gesture = UITapGestureRecognizer(target:self, action:"openConnections:")
            connections?.addGestureRecognizer(gesture)
        }
    }
    
    func sendEmail(sender:AnyObject) {
        println("mailto:"+email!)
        if self.email != nil {
            UIApplication.sharedApplication().openURL(mailToUrl!)
        }
    }
    
    func openConnections(sender:AnyObject) {
        if self.email != nil {
            UIApplication.sharedApplication().openURL(connectionsUrl!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

