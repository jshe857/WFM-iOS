//
//  ServerResponseDelegate.h
//  GradedTrust4iOS
//
//  Created by sara_wireless@in.ibm.com on 7/28/14.
//  Copyright (c) 2014 GBS. All rights reserved.
//
//  GradedTrust4iOS
//

#import <Foundation/Foundation.h>

@protocol ServerResponseDelegate <NSObject>

@optional

-(void) didFailToGetResult;
-(void) getResponse:(NSURLResponse *)response;
-(void) getJSONResultArray:(NSString *)responseString;

@end
