//
//  TPMGServiceError.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface TPMGServiceError : NSObject

// This method can be invoked if we are sending a whole response object, we want to make sure the status code in that response object is valid.
+ (BOOL)isResponseValid:(NSURLResponse *)iResponse;

// This method can be invoked if we want to make sure the given status code is valid.
// If the given status code is not valid and falls under one of the HTML error codes, it will thorw a generic error.
// The implementing application has to set the shouldAutoHandleServiceErrors boolean to YES in order to show the generic error.
+ (BOOL)isStatusCodeValid:(NSInteger)iStatusCode;

@end
