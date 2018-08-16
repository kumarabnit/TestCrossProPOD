//
//  TPMGImageDownloadRequest.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGImageDownloadRequest.h"


@interface TPMGImageDownloadRequest ()

@property (nonatomic, strong) void(^downloadCompletionBlock)(BOOL iSucceeded, UIImage *iImage);

@end

@implementation TPMGImageDownloadRequest


#pragma mark - Download request

- (void)downloadImageFromURL:(NSURL *)iImageURL completionBlock:(void(^)(BOOL iSucceeded, UIImage *iImage))iCompletionBlock {
	self.downloadCompletionBlock = iCompletionBlock;
	
	// Create and invoke the private session.
	NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration delegate:self delegateQueue:nil];
	NSURLSessionDownloadTask *anImageDownloadTask = [aURLSession downloadTaskWithURL:iImageURL];
	[anImageDownloadTask resume];
}


#pragma mark - Download Task Delegates

- (void)URLSession:(NSURLSession *)iSession downloadTask:(NSURLSessionDownloadTask *)iDownloadTask didFinishDownloadingToURL:(NSURL *)iLocation {
	NSData *anImageData = [NSData dataWithContentsOfURL:iLocation];
	UIImage *anImage = [UIImage imageWithData:anImageData];

	if (anImage) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.downloadCompletionBlock) {
				self.downloadCompletionBlock(YES, anImage);
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
