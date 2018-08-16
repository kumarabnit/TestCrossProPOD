//
//  BCCKeychain.h
//
//  Created by Buzz Andersen on 3/7/11.
//  Copyright 2013 Brooklyn Computer Club. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>


@interface TPMGKeychainUtility : NSObject

+ (NSString *)getPasswordStringForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error;
+ (NSData *)getPasswordDataForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error;

+ (BOOL)storeUsername:(NSString *)username andPasswordString:(NSString *)password forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError **)error;
+ (BOOL)storeUsername:(NSString *)username andPasswordData:(NSData *)passwordData forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError **)error;

+ (BOOL)deleteItemForUsername:(NSString *)username andServiceName:(NSString *)serviceName error:(NSError **)error;


/*
 Duplicating the existing methods to pass KeychainAccessGroup as a new parameter to Handle the Keychain isuue for Upgrade scenarios
 */
+ (NSString *)getPasswordStringForUsername:(NSString *)iUsername andServiceName:(NSString *)iServiceName accessGroup:(NSString *)iAccessGroup error:(NSError **)iError;
+ (NSData *)getPasswordDataForUsername:(NSString *)iUsername andServiceName:(NSString *)iServiceName accessGroup:(NSString *)iAccessGroup error:(NSError **)iError;

+ (BOOL)storeUsername:(NSString *)iUsername andPasswordString:(NSString *)iPassword forServiceName:(NSString *)iServiceName accessGroup:(NSString *)iAccessGroup updateExisting:(BOOL)iUpdateExisting error:(NSError **)iError;
+ (BOOL)storeUsername:(NSString *)iUsername andPasswordData:(NSData *)iPassword forServiceName:(NSString *)iServiceName accessGroup:(NSString *)iAccessGroup updateExisting:(BOOL)iUpdateExisting  error:(NSError **)iError;

+ (BOOL)deleteItemForUsername:(NSString *)iUsername andServiceName:(NSString *)iServiceName accessGroup:(NSString *)iAccessGroup error:(NSError **)iError;


@end

