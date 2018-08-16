//
//  NSString+Additions.h
//  TPMGCommon
//
//  Created by GK on 7/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface NSString (Additions)

// Base 64 encoding.
+ (NSString *)stringWithBase64EncodedString:(NSString *)iString;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

// Hashing
+ (NSString *)stringByHashingString:(NSString *)iString;

@end
