//
//  ListViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 19/11/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
    var employeeList:CSV?
    var list = [String]()
    var selectedKey = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = ["All"]
        if let values = employeeList?.getColumnValues(selectedKey) {
            list += values
        }
        //self.navigationItem.title = selectedKey
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if list[indexPath.row] != "All" {
            employeeList!.currFilters[selectedKey] = list[indexPath.row]
        } else {
            if employeeList?.currFilters[selectedKey] != nil    {
                 employeeList!.currFilters.removeValueForKey(selectedKey)
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("FilterUpdated", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath) as UITableViewCell
        if list[indexPath.row] != "" {
            (cell.viewWithTag(1) as UILabel).text = list[indexPath.row]
        } else {
            (cell.viewWithTag(1) as UILabel).text = "Unspecified"
        }

        return cell
    }
    
    
}
