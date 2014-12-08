//
//  Host.h
//  GradedTrust4iOS
//
//  Created by sara_wireless@in.ibm.com on 7/28/14.
//  Copyright (c) 2014 GBS. All rights reserved.
//
//  GradedTrust4iOS
//


#import <Foundation/Foundation.h>

#define SUCCESS                 @"Success"
#define FAILURE                 @"Failure"

@interface Host : NSObject{
    int connectionCount;
}

@property (nonatomic, assign) id delegate;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) NSString      *identifier;
@property(nonatomic, retain) NSString *urlPosition;

@property(nonatomic, retain) NSString *trustDetrminURL;
@property(nonatomic, retain) NSString *certVldtn;
@property(nonatomic, retain) NSString *usrAgnt;
@property(nonatomic, retain) NSString *dvcID;
@property(nonatomic, retain) NSString *trstLvl;

@property(nonatomic, readwrite) NSURLConnection *theConnection;
@property(nonatomic, readwrite) NSURLConnection *trustConnection;
@property(nonatomic, readwrite) NSURLConnection *redirectConnection;
@property(nonatomic, readwrite) NSMutableURLRequest *urlRequest;
@property(nonatomic, readwrite) NSMutableURLRequest *trusturlRequest;
@property(nonatomic, readwrite) NSMutableURLRequest *redirecturlRequest;
@property(nonatomic, readwrite) NSHTTPURLResponse* httpResponse;
@property(nonatomic, readwrite) NSURL *trusturl;

+ (Host*)host;
- (void) postJsonRequst:(NSString *)parametereStr  methodName:(NSString *)methodName;
- (void) authenticateOnGateway:(NSString *)deviceID sessionAuthenticationUrl:(NSString *)sessionAuthenticationUrl trustDeterminationURL:(NSString *)trustDeterminationURL username:(NSString *)username password:(NSString *)password userAgent:(NSString *)userAgent trustLevel:(NSString *)trustLevel certificateValidation:(NSString *)certificateValidation;
+ (NSString*) getAuthSessionCookie;
+ (NSString*) getTrustSessionCookie;
@end

