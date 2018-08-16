//
//  NSData+Additions.h
//  TPMGCommon
//
//  Created by GK on 7/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface NSData (Additions)

// Base 64 encoding.
+ (NSData *)dataWithBase64EncodedString:(NSString *)iString;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)iWrapWidth;
- (NSString *)base64EncodedString;

// AES256 Encryption
- (NSData *)AES256EncryptWithKey:(NSString *)iKey;
- (NSData *)AES256DecryptWithKey:(NSString *)iKey;

@end
