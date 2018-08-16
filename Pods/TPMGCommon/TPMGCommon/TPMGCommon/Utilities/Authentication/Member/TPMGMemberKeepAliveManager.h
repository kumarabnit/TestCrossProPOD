//
//  TPMGMemberKeepAliveManager.h
//  TPMGCommon
//
//  Created by GK on 6/24/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAuthenticationObject.h"
#import "TPMGServiceManager.h"


@interface TPMGMemberKeepAliveManager : TPMGAuthenticationObject

+ (void)renewSSOSession:(NSString *)iSSOSession cookieName:(NSString *)iCookieName URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

@end
