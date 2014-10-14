//
//  EmployeeURLDelegate.swift
//  WorkforceManagement
//
//  Created by IBM on 14/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
class EmployeeURLDelegate:NSObject,NSURLSessionDelegate,NSURLSessionTaskDelegate {
    let credential = NSURLCredential(user: "pracavai", password: "!q3e4r5t", persistence: NSURLCredentialPersistence.ForSession)
    func URLSession(session: NSURLSession,
    task: NSURLSessionTask,
    didReceiveChallenge: NSURLAuthenticationChallenge,
    completionHandler: (NSURLSessionAuthChallengeDisposition,
        NSURLCredential!) -> Void) {
            if(didReceiveChallenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                let trust = NSURLCredential(trust:didReceiveChallenge.protectionSpace.serverTrust)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, trust)
            } else if (didReceiveChallenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) {
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
            }
    }

    
    
}