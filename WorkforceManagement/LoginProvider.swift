//
//  LoginProvider.swift
//  WorkforceManagement
//
//  Created by IBM on 28/01/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation

class LoginProvider : NSObject, WLDelegate{

    func login(email:String,password:String) -> Bool{
        // TODO Login to IMC....
        
        
        // Check if user has access to right group
        let procedureCheckGroup = WLProcedureInvocationData(adapterName: "BlueGroupsAdapter", procedureName: "getGroup")
        //let procedureCheckGroup = WLProcedureInvocationData(adapterName: "PMPAdapter", procedureName: "getCSVList")
        WLClient.sharedInstance().invokeProcedure(procedureCheckGroup, withDelegate: self)
        
        return true
    }
    
    func onFailure(response: WLFailResponse!) { // Bluegroups data download unsuccessful - show error
        println("Login failure")
        NSNotificationCenter.defaultCenter().postNotificationName("userAuthenticationInvalid", object: nil)
    }
    func onSuccess(response:WLResponse!) { // Bluegroups data was downloaded,check if user in correct group
        println("Login Success")
        
        
        let responseData: NSData = response.responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let jsonObject = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary!
        
        println("JSON login")
        println(jsonObject)
        /*
        var jsonGroup = jsonObject["group"] as NSString!
        println("JSON group")
        println(jsonGroup)
        */
        
        NSNotificationCenter.defaultCenter().postNotificationName("userAuthenticationValid", object: nil)
        
    }

}