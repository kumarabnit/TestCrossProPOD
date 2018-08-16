//
//  TPMGMemberSignOnManager.h
//  TPMGCommon
//
//  Created by GK on 6/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAuthenticationObject.h"
#import "TPMGServiceManager.h"


@interface TPMGMemberSignOnManager : TPMGAuthenticationObject

// The parameters (includes both the body and headers) need to use the keys as specified in the TPMGServiceConstants class.

/*
	This API can be invoked to only authenticate the user with the given parameters.
 */
+ (void)authenticateUserWithURL:(NSURL *)iAuthenticationURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

/*
	This API can be invoked to check the system status before the actual authentication of the user.
 */
+ (void)authenticateUserWithURL:(NSURL *)iAuthenticationURL systemStatusCheckURL:(NSURL *)iSystemStatusCheckURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iBodyParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

/*
 	This API can be invoked to check the system status alone.
 */
+ (void)checkSystemStatusWithURL:(NSURL *)iSystemStatusCheckURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

@end
