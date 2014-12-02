//
//  MasterViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 9/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
class MasterViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    let filterTitles = ["availWks":"Availability","home":"Home Location","band":"Band","business":"Business Unit","jrss":"JRSS"]
    let filterBarShowHeight:CGFloat = 30.0
    
    var detailViewController: DetailViewController? = nil
    let employeeListProvider = EmployeeListProvider()
    var employeeList:CSV?
    var alert:UIAlertView?
    var updateDate = UILabel()
    
    @IBOutlet weak var filterBarHeight: NSLayoutConstraint!
    @IBOutlet weak var filterBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterNames: UILabel!
    @IBOutlet weak var clear: UIButton!
    

    var lastHeight:CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }


    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let filterButton = UIBarButtonItem(title:"Filter",style:UIBarButtonItemStyle.Plain, target:self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = filterButton
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem:.Refresh,target:self,action:"downloadCSV:")
        self.navigationItem.leftBarButtonItem = refreshButton
    
        //ios 7 iphones do not support splitview controllers
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }

        //Add observer to recieve notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidComplete", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "EmployeeListDidFail", object: nil)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.activityIndicator.layer.cornerRadius = 10
        self.activityIndicator.stopAnimating()
        
        
        // Display a message when the table is empty
        var messageLabel = UILabel(frame: CGRect(x: 0,y: 0, width: self.view.bounds.size.width,height: self.view.bounds.size.height))
        messageLabel.text = "";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center
        self.tableView.backgroundView = messageLabel
        
        
        
        //initialize alert error message
        self.alert = UIAlertView(title:"Could not reach server", message: "Please check your \n connection and try again.", delegate:nil ,cancelButtonTitle: "OK")
        
        //header view
        
        
      
        clear.addTarget(self,action:"clearFilter:",forControlEvents: UIControlEvents.TouchDown)
        
        filterBarHeight.constant = 0
        filterBar.hidden = true
        
        //start downloading data
        downloadCSV(self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showFilter(sender: AnyObject) {
        if employeeList != nil {
            self.performSegueWithIdentifier("showFilter",sender:nil)
        }
    }
    func clearFilter(sender: AnyObject) {
        employeeList?.applyFilters([String:String]())
        filterBarHeight.constant = 0
        filterBar.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("FilterUpdated",object: nil)
    }
    
    func downloadCSV(sender: AnyObject){
        if !activityIndicator.isAnimating() {
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.tableView.userInteractionEnabled = false
            employeeListProvider.refreshDB()
            
        } else {
            
            
        }
    }
    
    func refreshTable(sender: AnyObject) {
        

        employeeList = employeeListProvider.EmployeeList
        let notification = sender as NSNotification
        if (notification.name == "EmployeeListDidComplete") {
            let filters = employeeList!.getFilters()
            if filters?.count > 0 {
                
                var applied = "Filters: "
                for (key,val) in filters! {
                    applied += "\(filterTitles[key]!), "
                }
                applied = applied.substringToIndex(advance(applied.startIndex, countElements(applied)-2))
                filterNames.text = applied
                if filters?.count > 3 {
                    filterNames.font = UIFont.systemFontOfSize(12)
                }
                filterBarHeight.constant = filterBarShowHeight
                filterBar.hidden = false
            } else {
                filterBar.hidden = true
                filterBarHeight.constant = 0
            }
            
            //Code to add date to refresh display
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            let date = formatter.stringFromDate(NSDate())
            updateDate.text = "  Last update: \(date)"
            updateDate.textColor = UIColor.whiteColor()
            updateDate.backgroundColor = UIColor(red: 0.114, green: 0.467, blue: 0.937, alpha: 1.0)
            updateDate.frame = CGRectMake(0,0,self.view.bounds.size.width,22)
            updateDate.font = UIFont.boldSystemFontOfSize(14)
            tableView.tableHeaderView = updateDate
            
            
            self.tableView.reloadData()
            //dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()//})
            self.tableView.userInteractionEnabled = true
            
            
            
        } else  if (notification.name == "EmployeeListDidFail"){
            dispatch_async(dispatch_get_main_queue(), {self.alert!.show()})
            dispatch_async(dispatch_get_main_queue(), {self.activityIndicator.stopAnimating()})

        }
    }
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if let object = employeeList?.getRow(indexPath.row) {
                    var controller : DetailViewController
                    let idiom = UIDevice.currentDevice().userInterfaceIdiom
                    if idiom == UIUserInterfaceIdiom.Phone {
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

            let idiom = UIDevice.currentDevice().userInterfaceIdiom
            if idiom == UIUserInterfaceIdiom.Phone {
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = employeeList
        var background = (self.tableView.backgroundView as UILabel)
        if let length = list?.getCount() {

            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            background.text = nil
            return length
            
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            background.text = "No entries found"
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        if object?["availWks"] == "0" {
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


}

