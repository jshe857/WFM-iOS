//
//  FilterViewController.swift
//  WorkforceManagement
//
//  Created by IBM on 14/11/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

class FilterViewController : UITableViewController,UIPickerViewDataSource {
    var filterKeys: Dictionary<String,Array<String>> = ["Avaibility":["All","1 Week"]]

    var currFilters:Dictionary<String,String> = ["Availability":"All"]
    
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
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filter", forIndexPath: indexPath) as UITableViewCell
        var criteria = ""
        switch indexPath.row {
        case 0:
            criteria = "Availability"
        case 1:
            criteria = "Home Location"
        case 2:
            criteria = "Band"
        case 3:
            criteria = "Business Unit"
        case 4:
            criteria = "JRSS"
        default:
            break;
            
        }
        (cell.viewWithTag(1) as UILabel).text = criteria
        (cell.viewWithTag(2) as UITextField).text = currFilters[criteria]
        let picker  = UIPickerView()
        picker.dataSource = self
        
        (cell.viewWithTag(2) as UITextField).inputView = picker as UIView
        
        return cell
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
}