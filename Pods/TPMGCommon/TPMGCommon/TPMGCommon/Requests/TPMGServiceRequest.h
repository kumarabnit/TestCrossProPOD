//
//  TPMGServiceRequest.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGBaseServiceRequest.h"

@interface TMPGSessionTracker : NSObject
+(instancetype)sharedInstance;
+(void)startNewSessionTracking;
+(void)cancelCurrentSessionTracking;
@end

@protocol TPMGServiceRequestDelegate <NSObject,NSURLSessionDelegate>

- (void)requestDidSucceedWithResponse:(id)iResponse;
- (void)requestDidFailWithResponse:(id)iResponse;

@end


@interface TPMGServiceRequest : TPMGBaseServiceRequest <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) id<TPMGServiceRequestDelegate> delegate;

- (void)fireRequestWithURL:(NSURL *)iRequestURL;
- (void)fireAsynchorousRequestWithURL:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock;

- (void)fireBackgroundAsynchorousRequestWithURL:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock;
- (void)fireAsynchorousRequestWithURLForPUT:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock;

@end
