//
//  EmployeeListProvider.swift
//  WorkforceManagement
//
//  Created by IBM on 10/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
class EmployeeListProvider : NSObject, WLDelegate{
    var EmployeeList:CSV?
    var sessionToken:String?
    
    let url = NSURL(string:"https://sydgsa.ibm.com/projects/p/practitioneravailability/GBS%20Bench%20Report.csv") as NSURL?
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: EmployeeURLDelegate(), delegateQueue: nil)
    

    func refreshDB() {
        let task = session.dataTaskWithURL(url!, completionHandler:{data,response, error in
            if (error != nil) {
                println(error.localizedDescription)
                //NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidFail", object: nil)
                let filePath = NSBundle.mainBundle().pathForResource("GBS Bench Report",ofType:"csv")
                if (filePath != nil) {
                    let rawCSV = String(contentsOfFile:filePath!)
                    self.EmployeeList = CSV(String: rawCSV!)
                    NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
                }
            } else {
                let rawCSV = NSString(data:data, encoding: NSUTF8StringEncoding)
                if self.EmployeeList == nil {
                    self.EmployeeList = CSV(String: rawCSV!)
                } else {
                    self.EmployeeList!.update(rawCSV!)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
            }
        })
        task.resume()
    }
    
    func login(email:String,password:String) -> Bool{
        WLClient.sharedInstance().wlConnectWithDelegate(self)

//        let task = session.dataTaskWithURL(url!, completionHandler:{data,response, error in
//            if (error != nil) {
//                println(error.localizedDescription)
//            } else {
//                
//            }
//
//        
//        })
            
        
        return true
    }
    
    
    func onFailure(response: WLFailResponse!) {
        println(response.errorMsg)
    }
    func onSuccess(response:WLResponse!) {
        //println(response.responseText)
        println("we created!")
    }
}
