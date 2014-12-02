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
    
    //translate filter fields to db column keys
    let filterTitles = ["Availability","Home Location","Band","Business Unit","JRSS"]
    let filterKeys = ["availWks","home","band","business","jrss"]
    
    //translate db values to displayable text
    let availKeys = ["Now":"0","1 Week":"1","2 Weeks":"2", "3 Weeks":"3","4 Weeks":"4"]
    let reverseAvailKeys = ["0":"Now","1":"1 Week","2":"2 Weeks","3": "3 Weeks","4":"4 Weeks"]

    var currFilters:[String:String]?
    
    
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
        self.currFilters = employeeList?.getFilters()

        
        NSNotificationCenter.defaultCenter().addObserver(self,selector:"refresh:", name:"FilterUpdated", object:nil)

    }
    
    func refresh(sender:AnyObject) {
        
        if let list = sender.object as? ListViewController {
            currFilters![list.selectedKey] = list.selectedVal
        } else {
            currFilters = employeeList?.getFilters()
        }
        self.tableView.reloadData()
    }
    
    func applyFilter(sender:AnyObject) {
        
        employeeList?.applyFilters(currFilters!)
        NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterKeys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filter", forIndexPath: indexPath) as UITableViewCell
        var title = filterTitles[indexPath.row]
        (cell.viewWithTag(1) as UILabel).text = title
        var criteria = filterKeys[indexPath.row]
        

        if currFilters![criteria] != nil {
            
            if title == "Availability" {
                 (cell.viewWithTag(2) as UILabel).text = reverseAvailKeys[currFilters!["availWks"]!]
            } else {
                (cell.viewWithTag(2) as UILabel).text = currFilters![criteria]
            }
        } else {
            (cell.viewWithTag(2) as UILabel).text = "All"
        }
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
                let controller = segue.destinationViewController  as ListViewController
                controller.employeeList = employeeList
                controller.selectedKey = filterKeys[self.tableView.indexPathForSelectedRow()!.row]
                controller.navigationItem.title = filterTitles[self.tableView.indexPathForSelectedRow()!.row]
            
        }
    }

    
}