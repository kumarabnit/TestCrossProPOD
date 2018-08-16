//
//  TPMGBaseServiceRequest.h
//  TPMGCommon
//
//  Created by GK on 5/20/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceReachability.h"
#import "TPMGServiceConstants.h"

typedef void (^BackgroundCompletionBlock)(NSData *iData, NSURLResponse *iResponse, NSError *iError);

@interface TPMGBaseServiceRequest : NSObject

@property (nonatomic, strong) NSDictionary *requestBody;
@property (nonatomic, strong) NSString *JSONBody;
@property (nonatomic, strong) NSMutableData *dataBody;
@property (nonatomic, strong) NSData *immutableDataBody;
@property (nonatomic, strong) NSDictionary *requestHeaders;
@property (nonatomic, strong) NSString *requestHTTPMethod;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadDataTask;
@property (nonatomic, copy) BackgroundCompletionBlock completionBlock;


- (NSMutableURLRequest *)createHeaderForRequest:(NSMutableURLRequest *)iRequestURL;
- (NSMutableURLRequest *)createBodyForRequest:(NSMutableURLRequest *)iRequestURL;
- (NSMutableURLRequest *)generateRequestWithURL:(NSURL *)iRequestURL;

@end
