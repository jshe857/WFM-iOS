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
    var employeeList:CSV?
    var alert:UIAlertView?
    var updateDate:UILabel?
    var sectionHeader:UILabel?
    
    var lastHeight:CGFloat = 0
    
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target:self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = addButton
    
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidComplete", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidFail", object: nil)
        
        //refresh control set up
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
        
        
        //initialize alert error message
        self.alert = UIAlertView(title:"Could not reach server", message: "Please check your \n connection and try again.", delegate:nil ,cancelButtonTitle: "OK")
        

        

        
        

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
        //if !self.refreshControl!.refreshing && employeeList != nil {
            self.performSegueWithIdentifier("showFilter",sender:nil)
        //}
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
                
                //Code to add date to refresh control
//                let formatter = NSDateFormatter()
//                formatter.dateFormat = "MMM d, h:mm a"
//                let date = formatter.stringFromDate(NSDate())
//                let title = "Last update: \(date)"
                //let attrsDictionary = NSDictionary(object: (UIColor.whiteColor()),forKey: NSForegroundColorAttributeName)
//                let attributedTitle = NSMutableAttributedString(string: title )
//                attributedTitle.addAttribute(NSForegroundColorAttributeName,
//                    value: UIColor.whiteColor(),
//                    range: NSMakeRange(0, countElements(title)))
//                self.refreshControl!.attributedTitle = attributedTitle

                //Update table header
                updateDate = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width,height: 15))
                updateDate!.backgroundColor = UIColor.lightGrayColor()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMM d, h:mm a"
                let date = formatter.stringFromDate(NSDate())
                let title = "  Last update: \(date)"
                let font = UIFont(name: "Helvetica Bold", size:12.0)
                let attr = NSDictionary(objects:[font!,UIColor.whiteColor()],forKeys:[NSFontAttributeName,NSForegroundColorAttributeName])
                
                let attributedTitle = NSAttributedString(string: title, attributes: attr)
                
                updateDate!.attributedText = attributedTitle
                self.refreshControl!.endRefreshing()
            }
        } else  if (notification.name == "EmployeeListDidFail"){
            dispatch_async(dispatch_get_main_queue(), {self.alert!.show()})
            self.refreshControl!.endRefreshing()
        }
    }
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let object = employeeList?.getRow(indexPath.row) {
                    var controller : DetailViewController
                    if UIDevice.currentDevice().systemVersion.hasPrefix("7.") && UIDevice.currentDevice().localizedModel.hasPrefix("iPhone")    {
                        controller = segue.destinationViewController as DetailViewController
                    } else {
                        controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                    }
                    
                    controller.detailItem = object
                    if let split = self.splitViewController {
                        if split.respondsToSelector(Selector("displayModeButtonItem")){
                    
                            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                            controller.navigationItem.leftItemsSupplementBackButton = true
                        }
                    }
                }
            }
        } else if segue.identifier == "showFilter" {
            var controller: FilterViewController
            if UIDevice.currentDevice().systemVersion.hasPrefix("7.") && UIDevice.currentDevice().localizedModel.hasPrefix("iPhone") {
                controller = segue.destinationViewController as FilterViewController
            } else {
                controller = (segue.destinationViewController as UINavigationController).topViewController as FilterViewController
            }
            
            if employeeList != nil {
                controller.employeeList = employeeList!
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = employeeList
        var background = (self.tableView.backgroundView as UILabel)
        if let length = list?.getCount() {

            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            background.text = ""
            return length
            
        } else {
            
            background.text = "No data is currently available.\n Please pull up to refresh"
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = employeeList?.getRow(indexPath.row)
        //cell.textLabel?.text = object?.description
        
        //populate cell with csv data
        let nameText = cell.viewWithTag(1) as UILabel
        let locationText = cell.viewWithTag(2) as UILabel
        let deptText = cell.viewWithTag(3) as UILabel
        let jobText = cell.viewWithTag(4) as UILabel
        let availText = cell.viewWithTag(5) as UILabel
        let availDate = cell.viewWithTag(6) as UILabel
        
        
        nameText.text = object?["name"]
        deptText.text = object?["business"]
        
        locationText.text=object?["home"]
        jobText.text=object?["jrss"]
        
        if object?["availWk"] == "0" {
            availDate.text = "Now"
            let highlight = UIColor(red: 0.114, green: 0.467, blue: 0.937, alpha: 1.0)
            availDate.textColor = highlight
            availDate.font = UIFont.systemFontOfSize(14)
            availText.textColor = highlight
        } else {
            availDate.text = object?["availability"]
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


    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < self.lastHeight {
            sectionHeader = updateDate
        } else {
            sectionHeader = nil

        }
        self.tableView.reloadData()
        self.lastHeight = scrollView.contentOffset.y
    }

    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {

    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if sectionHeader == nil {
            return UIView(frame:CGRectMake(0, 0,  tableView.bounds.size.width, 1))
        }
        return sectionHeader
    }


}

