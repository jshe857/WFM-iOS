//
//  EmployeeURLDelegate.swift
//  WorkforceManagement
//
//  Created by IBM on 14/10/2014.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation

//connects directly to sydgsa
//provides functional id credentials to server
//accepts servers untrusted ssl certificate

class EmployeeURLDelegate:NSObject,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate {
    let credential = NSURLCredential(user: "pracavai", password: "!u8i9o0p", persistence: NSURLCredentialPersistence.ForSession)
    let failed = 0;
    func URLSession(session: NSURLSession,
    task: NSURLSessionTask,
    didReceiveChallenge: NSURLAuthenticationChallenge,
    completionHandler: (NSURLSessionAuthChallengeDisposition,
        NSURLCredential!) -> Void) {
            if(didReceiveChallenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                let trust = NSURLCredential(trust:didReceiveChallenge.protectionSpace.serverTrust)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, trust)
            } else if (didReceiveChallenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) {
                
                if (didReceiveChallenge.previousFailureCount > 2) {
                    completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge,credential)
                } else {
                    completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
                }

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