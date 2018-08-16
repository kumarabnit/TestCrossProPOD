//
//  TPMGFileDownloadRequest.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGFileDownloadRequest.h"


@interface TPMGFileDownloadRequest ()

@property (nonatomic, strong) void(^downloadCompletionBlock)(BOOL iSucceeded, NSData *iFileResponseData);

@end

@implementation TPMGFileDownloadRequest


#pragma mark - Download request

- (void)downloadFileFromURL:(NSURL *)iURL completionBlock:(void(^)(BOOL iSucceeded, NSData *iFileResponseData))iCompletionBlock {
	self.downloadCompletionBlock = iCompletionBlock;
	
	NSMutableURLRequest *aRequest = [[NSMutableURLRequest alloc] init];
	[aRequest setURL:iURL];
	[aRequest setHTTPMethod:self.requestHTTPMethod];
	[self createHeaderForRequest:aRequest];
	[self createBodyForRequest:aRequest];
	
	// Create and invoke the session
	NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration delegate:self delegateQueue:nil];
	NSURLSessionDownloadTask *aFileDownloadTask = [aURLSession downloadTaskWithRequest:aRequest];
	[aFileDownloadTask resume];
}


#pragma mark - Download Task Delegates

- (void)URLSession:(NSURLSession *)iSession downloadTask:(NSURLSessionDownloadTask *)iDownloadTask didFinishDownloadingToURL:(NSURL *)iLocation {
	NSData *aFileData = [NSData dataWithContentsOfURL:iLocation];
	
	if (aFileData) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.downloadCompletionBlock) {
				self.downloadCompletionBlock(YES, aFileData);
			}
		});
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.downloadCompletionBlock) {
				self.downloadCompletionBlock(NO, nil);
			}
		});
	}
}


- (void)URLSession:(NSURLSession *)iSession downloadTask:(NSURLSessionDownloadTask *)iDownloadTask didResumeAtOffset:(int64_t)iFileOffset expectedTotalBytes:(int64_t)iExpectedTotalBytes {
	
}


- (void)URLSession:(NSURLSession *)iSession downloadTask:(NSURLSessionDownloadTask *)iDownloadTask didWriteData:(int64_t)iBytesWritten totalBytesWritten:(int64_t)iTotalBytesWritten totalBytesExpectedToWrite:(int64_t)iTotalBytesExpectedToWrite {
	
}


@end
