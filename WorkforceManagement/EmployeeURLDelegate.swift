//
//  EmployeeURLDelegate.swift
//  WorkforceManagement
//
//  Created by IBM on 14/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
class EmployeeURLDelegate:NSObject,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate {
    let credential = NSURLCredential(user: "pracavai", password: "!q3e4r5t", persistence: NSURLCredentialPersistence.ForSession)
    let progress = 0.0
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
    func URLSession(session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveData: NSData) {
            println("recieving")
            
    }
    func URLSession(session: NSURLSession,
        dataTask: NSURLSessionDataTask,
        didReceiveResponse: NSURLResponse,
        completionHandler: (NSURLSessionResponseDisposition) -> Void) {
            println("response")
            
    }
}