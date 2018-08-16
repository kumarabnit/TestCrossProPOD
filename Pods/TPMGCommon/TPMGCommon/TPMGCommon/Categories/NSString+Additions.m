//
//  NSString+Additions.m
//  TPMGCommon
//
//  Created by GK on 7/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "NSString+Additions.h"
#import "NSData+Additions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Additions)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string {
    NSData *data = [NSData dataWithBase64EncodedString:string];
	NSString *aReturnValue = nil;
	
    if (data) {
        aReturnValue = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
	
    return aReturnValue;
}


- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}


- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}


- (NSString *)base64DecodedString {
    return [NSString stringWithBase64EncodedString:self];
}


- (NSData *)base64DecodedData {
    return [NSData dataWithBase64EncodedString:self];
}


+ (NSString *)stringByHashingString:(NSString *)iString {
    const char *aCharacterString = [iString cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSData *aData = [NSData dataWithBytes:aCharacterString length:iString.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
	
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(aData.bytes, (uint32_t)aData.length, digest);
	
    NSMutableString *aReturnString = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
	
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for (NSUInteger i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [aReturnString appendFormat:@"%02x", digest[i]];
    }
	
    return aReturnString;
}



@end
