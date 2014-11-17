//
//  DetailViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

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

        if let detail: Array<String> = self.detailItem as? Array<String>{
            self.navigationItem.title = detail[1]
            
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

