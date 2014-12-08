//
//  GradedTrustSDK.h
//  GradedTrust4iOS
//
//  Created by sara_wireless@in.ibm.com on 16/09/14.
//  Copyright (c) 2014 GBS. All rights reserved.
//

#ifndef GradedTrust4iOS_GradedTrustSDK_h
#define GradedTrust4iOS_GradedTrustSDK_h


#endif

#import "ServerResponseDelegate.h"
#import "GradedTrustDelegate.h"
#import <UIKit/UIKit.h>

@interface GradedTrustSDK : NSObject{
    NSData *appConfigData;
    NSString *appConfigString;
}

@property (nonatomic, assign) id delegate;
+(GradedTrustSDK *)gtSdk;

- (NSString *)getDeviceID;
- (NSString *)decryptUsernameAndPassword;
- (NSString *)encryptUsernameAndPassword:(NSString *)userName password:(NSString *)password;
- (NSString *)authenticateAndEstablishTrust:(NSString *)deviceID sessionAuthenticationUrl:(NSString *)sessionauthURL trustDeterminationURL:(NSString *)trustDtrURL username:(NSString *)usrName password:(NSString *)passWord userAgent:(NSString *)usrAgnt trustLevel:(NSString *)trustLvl certificateValidation:(NSString *)certValidation;
- (NSString *)getAuthSessionCookie;
- (NSString *)getTrustSessionCookie;
- (void)viewDocumentInSecureViewer;
- (NSURL *)getTemporarySaveURL;
- (NSString *)getTemporarySavePath;
- (NSString *)retriveAppConfig;
- (NSString *)getAppConfig;
- (void) initMaaS360SDK:(NSString *)licensekey developerid:(NSString *)developerid;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
