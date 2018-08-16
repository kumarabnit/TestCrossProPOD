//
//  TPMGMemberSignOffManager.h
//  TPMGCommon
//
//  Created by GK on 6/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAuthenticationObject.h"
#import "TPMGServiceManager.h"


@interface TPMGMemberSignOffManager : TPMGAuthenticationObject

/* Sign off the user using this API
 * iParameters is the dictionary with keys SSO Session, App name and API key.
 */
+ (void)signOffUserWithURL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(void(^)(BOOL iSucceeded, id iResponseObject))iCompletionBlock;

@end
