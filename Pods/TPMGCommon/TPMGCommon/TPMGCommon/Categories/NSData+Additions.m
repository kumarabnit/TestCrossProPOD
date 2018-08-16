//
//  NSData+Additions.m
//  TPMGCommon
//
//  Created by GK on 7/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "NSData+Additions.h"
#import <CommonCrypto/CommonCryptor.h>


#if !__has_feature(objc_arc)
#error This library requires automatic reference counting
#endif

@implementation NSData (Additions)


#pragma mark - Base 64 Encoding

+ (NSData *)dataWithBase64EncodedString:(NSString *)iString {
    const char lookup[] = {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [iString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSUInteger inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    NSUInteger maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    NSUInteger accumulator = 0;
    NSUInteger outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (NSUInteger i = 0; i < inputLength; i++) {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
		
        if (decoded != 99) {
            accumulated[accumulator] = decoded;
			
            if (accumulator == 3) {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
			
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) {
		outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
	}
	
    if (accumulator > 1) {
		outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
	}
	
    if (accumulator > 2) {
		outputLength++;
	}
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength ? outputData: nil;
}


- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)iWrapWidth {
    //ensure wrapWidth is a multiple of 4
    iWrapWidth = (iWrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSUInteger inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    NSUInteger maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += iWrapWidth ? (maxOutputLength / iWrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    unsigned char *outputBytesRealloc;
    
	// Added the below check for security.
	if (!outputBytes) {
		return nil;
	}
	
    NSUInteger i;
    NSUInteger outputLength = 0;
	
    for (i = 0; i < inputLength - 2; i += 3) {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (iWrapWidth && (outputLength + 2) % (iWrapWidth + 2) == 0) {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2) {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    } else if (i == inputLength - 1) {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4) {
        //truncate data to match actual output length
        outputBytesRealloc = realloc(outputBytes, outputLength);
		
		// Added the below check for security.
		if (outputBytesRealloc == nil) {
            free(outputBytes);
			return nil;
		}
		
        return [[NSString alloc] initWithBytesNoCopy:outputBytesRealloc
                                              length:outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    } else if (outputBytes) {
        free(outputBytes);
    }
	
    return nil;
}


- (NSString *)base64EncodedString {
    return [self base64EncodedStringWithWrapWidth:0];
}


#pragma mark - AES256 Encryption / Decryption

- (NSData *)AES256EncryptWithKey:(NSString *)iKey {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	BOOL patchNeeded = ([iKey length] > kCCKeySizeAES256);
	if (patchNeeded) {
		iKey = [iKey substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
	}
	
	// fetch key data
	[iKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSISOLatin1StringEncoding];
	
	if (patchNeeded) {
		keyPtr[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
	}
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES256,
										  NULL /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)iKey {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	BOOL patchNeeded = ([iKey length] > kCCKeySizeAES256);
	if (patchNeeded) {
		iKey = [iKey substringToIndex:kCCKeySizeAES256]; // Ensure that the key isn't longer than what's needed (kCCKeySizeAES256)
	}
	
	// fetch key data
	[iKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSISOLatin1StringEncoding];
	
	if (patchNeeded) {
		keyPtr[0] = '\0';  // Previous iOS version than iOS7 set the first char to '\0' if the key was longer than kCCKeySizeAES256
	}
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES256,
										  NULL /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}


@end
