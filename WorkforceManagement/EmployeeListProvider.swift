//
//  EmployeeListProvider.swift
//  WorkforceManagement
//
//  Created by IBM on 10/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
class EmployeeListProvider {
    var EmployeeList:CSV?
    let url = NSURL(string:"https://sydgsa.ibm.com/projects/p/practitioneravailability/GBS%20Bench%20Report.csv") as NSURL?
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: EmployeeURLDelegate(), delegateQueue: nil)
    
    init() {
    }
    
    func refreshDB() {
        let task = session.dataTaskWithURL(url!, completionHandler:{data,response, error in
            if (error != nil) {
                println(error.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidFail", object: nil)
            } else {
                let rawCSV = NSString(data:data, encoding: NSUTF8StringEncoding)
                var filters:[String:String]?
                if self.EmployeeList != nil {
                   filters = self.EmployeeList?.currFilters
                }
                self.EmployeeList = CSV(csvString: rawCSV, delimiter: NSCharacterSet(charactersInString: ","),filters:filters)
                NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
            }
        })
        task.resume()
    }
}
