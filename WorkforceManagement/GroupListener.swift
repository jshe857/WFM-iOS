//
//  GroupListener.swift
//  WorkforceManagement
//
//  Created by IBM on 28/01/2015.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation

class GroupListener: NSObject, WLDelegate {
    
    //let elistProvider = EmployeeListProvider()
    
    var didSuccess: ((WLResponse!)->())
    var didFailure: ((WLFailResponse!)->())
    
    //var isSuccess = Bool()
    
    func onFailure(response: WLFailResponse!) { // Return error
       // isSuccess = false
        println("Group Listener Failure")
    }
    func onSuccess(response:WLResponse!) { // Return group data
        //isSuccess = true
        println("Group Listener Success")
    }
    
    init (
        didSuccess:((WLResponse!)->())? = nil,
        didFailure:((WLFailResponse!)->())? = nil
    ) {
        self.didSuccess = didSuccess!
        self.didFailure = didFailure!
    }
    
    
    
}