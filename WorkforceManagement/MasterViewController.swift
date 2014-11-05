    //
//  MasterViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    let employeeListProvider = EmployeeListProvider()
    var employeeList:CSV? = nil
    var alert:UIAlertView? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showFilter:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidComplete", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidFail", object: nil)
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action:"downloadCSV",forControlEvents:.ValueChanged)
        self.refreshControl!.backgroundColor = UIColor(red: 0.227, green: 0.588, blue: 0.988, alpha: 1.0)
        
        // Display a message when the table is empty
        var messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width,height: self.view.bounds.size.height))
        
        messageLabel.text = "";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center
        
        self.tableView.backgroundView = messageLabel
        
        self.alert = UIAlertView()
        self.alert!.title = "Could not reach server"
        self.alert!.message = "Please check your \n connection and try again."
        self.alert!.addButtonWithTitle("OK")


    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showFilter(sender: AnyObject) {
    
    }
    func downloadCSV(){
        employeeListProvider.refreshDB()
    }
    func refreshTable(sender: AnyObject) {
        employeeList = employeeListProvider.EmployeeList
        
        let notification = sender as NSNotification
        if (notification.name == "EmployeeListDidComplete") {
            self.tableView.reloadData()
            if (self.refreshControl != nil) {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMM d, h:mm a"
                let date = formatter.stringFromDate(NSDate())
                let title = "Last update: \(date)"
                //let attrsDictionary = NSDictionary(object: (UIColor.whiteColor()),forKey: NSForegroundColorAttributeName)
                let attributedTitle = NSMutableAttributedString(string: title )
                attributedTitle.addAttribute(NSForegroundColorAttributeName,
                    value: UIColor.whiteColor(),
                    range: NSMakeRange(0, countElements(title)))
                self.refreshControl!.attributedTitle = attributedTitle
                
                self.refreshControl!.endRefreshing()
            }
        } else  if (notification.name == "EmployeeListDidFail"){

            alert!.show()
            self.refreshControl!.endRefreshing()

        }
    }
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let object = employeeList?.rows[indexPath.row] {
                    var controller : DetailViewController

                    if UIDevice.currentDevice().systemVersion.hasPrefix("7.") {
                        controller = segue.destinationViewController as DetailViewController
                    } else {
                        controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController

                    }
                    
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = employeeList
        if let length = list?.rows.count {

            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = nil
            return length
            
        } else {
            var background = (self.tableView.backgroundView as UILabel)
            background.text = "No data is currently unavailable.\n Please pull up to refresh"


        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = employeeList?.rows[indexPath.row]
        //cell.textLabel?.text = object?.description
        let nameText = cell.viewWithTag(1) as UILabel
        let locationText = cell.viewWithTag(2) as UILabel
        let deptText = cell.viewWithTag(3) as UILabel
        let jobText = cell.viewWithTag(4) as UILabel
        let availText = cell.viewWithTag(5) as UILabel
        let availDate = cell.viewWithTag(6) as UILabel
        nameText.text = object?[1]
        deptText.text = object?[14]
        
        locationText.text=object?[3]
        jobText.text=object?[28]
        if object?[17] == "0" {
            availDate.text = "Now"
            let highlight = UIColor(red: 0.114, green: 0.467, blue: 0.937, alpha: 1.0)
            availDate.textColor = highlight
            availDate.font = UIFont.systemFontOfSize(14)
            availText.textColor = highlight
        } else {
            availDate.text = object?[11]
            availDate.textColor = UIColor.darkGrayColor()
            availDate.font = UIFont.systemFontOfSize(12)
            availText.textColor = UIColor.darkGrayColor()
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }


}

