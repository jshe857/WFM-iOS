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

    class func sharedInstance() -> EmployeeListProvider {
        return _sharedInstance
    }

    
    let url = NSURL(string:"https://sydgsa.ibm.com/projects/p/practitioneravailability/GBS%20Bench%20Report.csv") as NSURL?
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: EmployeeURLDelegate(), delegateQueue: nil)
    

    // Download CSV DB
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
    
    // We want to connect to the WL Server here & download the CSV file
    // This connects to IMC which then goes through the firewall to WAS
    // WAS downloads the CSV file from SYDGSA & passes it back
    func downloadCSV() {
        /* Run getCSV WL app fromserver specified in worklight.plist, this will attempt to DL the CSV File
        If successful it runs on success, otherwise it runs on failure */

        let procedure = WLProcedureInvocationData(adapterName: "PMPAdapter", procedureName: "getCSVList")
        WLClient.sharedInstance().invokeProcedure(procedure, withDelegate: self)
        
    }
    
    

    func onFailure(response: WLFailResponse!) { // WL to download CSV was unsuccessfull, use local CSV
        println(response.errorMsg)
        let filePath = NSBundle.mainBundle().pathForResource("GBS Bench Report",ofType:"csv")
        if (filePath != nil) {
            let rawCSV = String(contentsOfFile:filePath!)
            self.EmployeeList = CSV(String: rawCSV!)
            NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidFail", object: nil)
        }
    }
    func onSuccess(response:WLResponse!) { // WL to download CSV was successfull
        
        let responseData: NSData = response.responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let jsonObject = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var rawCSV = jsonObject["text"] as NSString
        
        //println("JSON csv")
        //println(jsonObject)
        
        if self.EmployeeList == nil {
            self.EmployeeList = CSV(String: rawCSV)
        } else {
            self.EmployeeList!.update(rawCSV)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("EmployeeListDidComplete", object: nil)
        
    }
}


let _sharedInstance : EmployeeListProvider = { EmployeeListProvider() }()

