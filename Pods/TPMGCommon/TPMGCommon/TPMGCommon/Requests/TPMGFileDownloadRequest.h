//
//  TPMGFileDownloadRequest.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGBaseServiceRequest.h"


@interface TPMGFileDownloadRequest : TPMGBaseServiceRequest <NSURLSessionDownloadDelegate>

- (void)downloadFileFromURL:(NSURL *)iURL completionBlock:(void(^)(BOOL iSucceeded, NSData *iFileResponseData))iCompletionBlock;

@end
