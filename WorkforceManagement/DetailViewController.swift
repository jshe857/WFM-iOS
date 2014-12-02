//
//  DetailViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var band: UILabel!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var jrss: UILabel!
    @IBOutlet weak var manager: UILabel!
    @IBOutlet weak var project: UILabel!
    
    var email:String?


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
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
                let faceUrl = NSURL(string:"http://faces.tap.ibm.com/api/find/?q=uid:"+serial+"&location:AU&limit=1")!
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:faceUrl),queue:NSOperationQueue(),
                    completionHandler: {response,data, error in
                        if (error != nil) {
                        } else {
                            var jsonError:NSError?
                           if let json = NSJSONSerialization.JSONObjectWithData(data,options:NSJSONReadingOptions.MutableContainers,error:&jsonError) as? NSArray {
                                self.email = (json[0] as NSDictionary)["email"] as String?
                                println(email)
                            }
                        }
                })

            }
            let emailBtn = self.view.viewWithTag(1) as UIButton
            emailBtn.addTarget(self, action:"sendEmail:", forControlEvents:UIControlEvents.TouchDown)
            
        }
    }
    
    func sendEmail(sender:AnyObject) {
        println(email)
        UIApplication.sharedApplication().openURL(NSURL(string:email!)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.configureView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

