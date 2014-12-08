//
//  Base64.h
//  GradedTrust4iOS
//
//  Created by Saravanan on 08/09/14.
//  Copyright (c) 2014 GBS. All rights reserved.
//

#ifndef GradedTrust4iOS_Base64_h
#define GradedTrust4iOS_Base64_h


#endif

#import <Foundation/Foundation.h>


@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end


@interface NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end