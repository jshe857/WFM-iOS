//
//  FilterViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 14/11/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit
import Foundation
class FilterViewController : UITableViewController {
    var employeeList:CSV?
    var filterTitles = ["Availability","Home Location","Band","Business Unit","JRSS"]
    var filterKeys = ["Wks to Avail","Home Location","Band","Business Unit","JRSS"]
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target:self, action: "applyFilter:")
        self.navigationItem.rightBarButtonItem = doneButton
        NSNotificationCenter.defaultCenter().addObserver(self,selector:"refresh:", name:"FilterUpdated", object:nil)

    }
    
    func refresh(sender:AnyObject) {
        self.tableView.reloadData()
    }
    
    func applyFilter(sender:AnyObject) {
        employeeList!.applyFilters()
        NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterKeys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filter", forIndexPath: indexPath) as UITableViewCell
        var criteria = filterTitles[indexPath.row]
        (cell.viewWithTag(1) as UILabel).text = criteria
        if let currFilter = employeeList?.currFilters[criteria] {
            (cell.viewWithTag(2) as UILabel).text = currFilter
        } else {
            (cell.viewWithTag(2) as UILabel).text = "All"
        }
        
        return cell
    }
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        selectedKey = (selectedCell?.viewWithTag(1)? as UILabel).text!
//        self.performSegueWithIdentifier("show", sender: nil)
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
                let controller = segue.destinationViewController  as ListViewController
                controller.employeeList = employeeList
                controller.selectedKey = filterKeys[self.tableView.indexPathForSelectedRow()!.row]
                controller.navigationItem.title = filterTitles[self.tableView.indexPathForSelectedRow()!.row]
            
        }
    }

    
}