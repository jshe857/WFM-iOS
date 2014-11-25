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
            name.text = detail["Name"]
                availability.text = detail["Avail Date"]
            jrss.text = detail["JRSS"]
            band.text = detail["Band"]
            home.text = detail["Home Location"]
            business.text = detail["Business Unit"]
            manager.text = detail["Manager"]
            project.text = detail["Current Or Most Recent Client/Customer Assignment"]
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

