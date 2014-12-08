//
//  GradedTrustDelegate.h
//  GradedTrust4iOS
//
//  Created by Saravanan on 16/10/14.
//  Copyright (c) 2014 GBS. All rights reserved.
//

#ifndef GradedTrust4iOS_GradedTrustDelegate_h
#define GradedTrust4iOS_GradedTrustDelegate_h


#endif

#import <Foundation/Foundation.h>

@protocol GradedTrustDelegate <NSObject>

@optional

-(void) did_FailToGetResult;
-(void) get_Response:(NSURLResponse *)response;
-(void) get_JSONResultArray:(NSString *)responseString;

@end
