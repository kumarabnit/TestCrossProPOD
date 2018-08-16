//
//  TPMGImageDownloadRequest.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface TPMGImageDownloadRequest : NSObject <NSURLSessionDownloadDelegate>

- (void)downloadImageFromURL:(NSURL *)iImageURL completionBlock:(void(^)(BOOL iSucceeded, UIImage *iImage))iCompletionBlock;

@end
