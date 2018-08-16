//
//  TPMGSignOnInterruptManager.h
//  JVFloatLabeledTextField
//
//  Created by Amardeep Kaur on 18/06/18.
//

#import "TPMGAuthenticationObject.h"
#import "TPMGServiceManager.h"
#import <Foundation/Foundation.h>

@interface TPMGSSOInterruptManager : TPMGAuthenticationObject

+ (void)tokenAPIToFetchClientCookieHeader:(NSDictionary *)iHeaderDictionary URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

+ (void)signOnInterruptURLWith:(NSURL *)iURL header:(NSDictionary *)iHeaderDictionary method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSData *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

+ (void)portalApiWithHeaderParameter:(NSDictionary *)iHeaderDictionary URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

@end
