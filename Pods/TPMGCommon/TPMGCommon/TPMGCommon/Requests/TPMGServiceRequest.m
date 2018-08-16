//
//  TPMGServiceRequest.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceRequest.h"
#import "TPMGServiceError.h"
#import "TPMGAuthenticationChallengeHandler.h"

#define kNetworkReachabilityDomain @"NetworkReachabilityDomain"
#define kNoNetworkConnection -101

@interface TMPGSessionTracker ()
@property(nonatomic, strong) NSDictionary* inFlightByUUIDs;
@property(nonatomic, strong) NSUUID* currentUUID;

-(void)trackASession:(id)theSession;
-(BOOL)isResponseStillValid:(id)theSession;

@end

@implementation TMPGSessionTracker
+(instancetype)sharedInstance {
    static TMPGSessionTracker *singletonTMPGSessionTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonTMPGSessionTracker = [[TMPGSessionTracker alloc] init];
    });
    
    return singletonTMPGSessionTracker;
}

+(void)startNewSessionTracking {
    
    [TMPGSessionTracker sharedInstance].currentUUID = [NSUUID UUID];
    
}

+(void) cancelCurrentSessionTracking {
    [TMPGSessionTracker sharedInstance].currentUUID = nil;
}

-(id) init {
    if (self = [super init]) {
        self.inFlightByUUIDs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) trackASession:(id)theSession {
    if (self.currentUUID != nil) {
        NSMutableArray* tempArray = nil;
        @synchronized(self) {
            tempArray = [self.inFlightByUUIDs objectForKey:self.currentUUID.UUIDString];
            if (tempArray == nil) {
                tempArray = [[NSMutableArray alloc] init];
            }
            [tempArray addObject:theSession];
            [self.inFlightByUUIDs setValue:tempArray forKey:self.currentUUID.UUIDString];
        }
    }
}

-(BOOL)isResponseStillValid:(id)theSession {
    BOOL retBoolVal = NO;
    
    NSArray* theKeys;
    theKeys = [self.inFlightByUUIDs allKeysForObject:theSession];
    if (theKeys.count == 0) {
        // if there are no keys for that object, then let the response go through OK. Likely a sign-in object.
        retBoolVal = YES;
    } else {
        if (self.currentUUID == nil) {
            // The session has been cleared, but we have transactions with UUIDs so this should obviously be ignored.
            for (NSString* aKey in theKeys) {  // Should just be one, but just in case.
                NSMutableArray* sessionArray = [self.inFlightByUUIDs objectForKey:aKey];
                [sessionArray removeObject:theSession];
                [self.inFlightByUUIDs setValue:sessionArray forKey:aKey];
            }
        }
        retBoolVal = NO;
        for (NSString* aKey in theKeys) {
            // usually should just be one, but just in case.
            NSString* tempUUIDString = self.currentUUID.UUIDString;
            if ((tempUUIDString != nil) && ([aKey compare:tempUUIDString] == NSOrderedSame)) {
                // good transaction - let it go through.
                retBoolVal = YES;
            }
            // pass or fail, remove it from the list.
            NSMutableArray* sessionArray = [self.inFlightByUUIDs objectForKey:aKey];
            [sessionArray removeObject:theSession];
            [self.inFlightByUUIDs setValue:sessionArray forKey:aKey];
        }
    }
    
    return retBoolVal;
}

@end



@interface TPMGServiceRequest ()

@property (nonatomic, strong) NSTimer *requestTimer;

@end

@implementation TPMGServiceRequest


#pragma mark - Request

- (void)fireRequestWithURL:(NSURL *)iRequestURL {
	NSMutableURLRequest *aNetworkRequest = [self generateRequestWithURL:iRequestURL];
	
    // Clear the request whenever you fire a new one.
    [self purgeRequest];
    
    // Create a default session configuration and set the request timeout.
    NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    aConfiguration.timeoutIntervalForRequest = kServiceRequestTimeOutInSeconds;
    
    NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.dataTask = [aURLSession dataTaskWithRequest:aNetworkRequest];
    [self.dataTask resume];
    
    [self setupRequestTimer];
}


- (void)fireAsynchorousRequestWithURL:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock {
	NSMutableURLRequest *aNetworkRequest = [self generateRequestWithURL:iRequestURL];
    
    if(self.dataBody) {
      [aNetworkRequest setHTTPBody:self.dataBody];
    }
    
    NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    aConfiguration.timeoutIntervalForRequest = kServiceRequestTimeOutInSeconds;
    
    NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration];
    
    self.dataTask = [aURLSession dataTaskWithRequest:aNetworkRequest completionHandler:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSHTTPURLResponse* anHTTPURLResponse = (NSHTTPURLResponse*)iResponse;
            if ((anHTTPURLResponse != nil) && (anHTTPURLResponse.statusCode == 200)) {
                
                if (iCompletionBlock) {
                    iCompletionBlock(iData, iResponse, iError);
                }
                
            } else {
                if (iCompletionBlock) {
                    NSError* tempError = iError;
                    if (tempError == nil) {
                        tempError = [NSError errorWithDomain:NSURLErrorDomain
                                                        code:NSURLErrorUnknown
                                                    userInfo:@{@"httpStatusCode":[NSNumber numberWithInteger:anHTTPURLResponse.statusCode]}];
                    } else {
                        if (([tempError.domain caseInsensitiveCompare:NSURLErrorDomain] == NSOrderedSame) && (tempError.code == NSURLErrorNotConnectedToInternet)) {
                            tempError = [[NSError alloc] initWithDomain:kNetworkReachabilityDomain code:kNoNetworkConnection userInfo:nil];
                        }
                    }
                    iCompletionBlock(iData, iResponse, tempError);
                }
            }
        });
    }];
    
    [self.dataTask resume];
}

- (void)fireAsynchorousRequestWithURLForPUT:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock {
    NSMutableURLRequest *aNetworkRequest = [self generateRequestWithURL:iRequestURL];
    
    if(self.immutableDataBody) {
        [aNetworkRequest setHTTPBody:self.immutableDataBody];
    }
    
    NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    aConfiguration.timeoutIntervalForRequest = kServiceRequestTimeOutInSeconds;
    
    NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration];
    
    self.dataTask = [aURLSession dataTaskWithRequest:aNetworkRequest completionHandler:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSHTTPURLResponse* anHTTPURLResponse = (NSHTTPURLResponse*)iResponse;
            if ((anHTTPURLResponse != nil) && (anHTTPURLResponse.statusCode == 200)) {
                
                if (iCompletionBlock) {
                    iCompletionBlock(iData, iResponse, iError);
                }
                
            } else {
                if (iCompletionBlock) {
                    NSError* tempError = iError;
                    if (tempError == nil) {
                        tempError = [NSError errorWithDomain:NSURLErrorDomain
                                                        code:NSURLErrorUnknown
                                                    userInfo:@{@"httpStatusCode":[NSNumber numberWithInteger:anHTTPURLResponse.statusCode]}];
                    } else {
                        if (([tempError.domain caseInsensitiveCompare:NSURLErrorDomain] == NSOrderedSame) && (tempError.code == NSURLErrorNotConnectedToInternet)) {
                            tempError = [[NSError alloc] initWithDomain:kNetworkReachabilityDomain code:kNoNetworkConnection userInfo:nil];
                        }
                    }
                    iCompletionBlock(iData, iResponse, tempError);
                }
            }
        });
    }];
    
    [self.dataTask resume];
}

- (void)fireBackgroundAsynchorousRequestWithURL:(NSURL *)iRequestURL completionBlock:(void(^)(NSData *iData, NSURLResponse *iResponse, NSError *iError))iCompletionBlock {
    NSMutableURLRequest *aNetworkRequest = [self generateRequestWithURL:iRequestURL];
    
    self.completionBlock = iCompletionBlock;
    
    if(self.dataBody) {
        [aNetworkRequest setHTTPBody:self.dataBody];
    }
    
    NSURLSessionConfiguration *aConfiguration = [NSURLSessionConfiguration  backgroundSessionConfigurationWithIdentifier:@"org.kp.tpmg.mymeds"];
    aConfiguration.sessionSendsLaunchEvents = YES;
    NSURLSession *aURLSession = [NSURLSession sessionWithConfiguration:aConfiguration delegate:self delegateQueue:nil];
    self.downloadDataTask = [aURLSession downloadTaskWithRequest:aNetworkRequest];
    [self.downloadDataTask resume];
}

#pragma mark - Private Methods.

- (void)parseResponse {
	if (self.responseData) {
		NSError *anError = nil;
		NSDictionary *aResponseDictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:&anError];
		
		if (anError != nil) {
			// If the parsing of the data fails, read the data in the NSISOLatin1StringEncoding and reconvert it to NSUTF8StringEncoding.
			anError = nil;
			NSString *aJsonString = [[NSString alloc] initWithData:self.responseData encoding:NSISOLatin1StringEncoding];
			aResponseDictionary = [NSJSONSerialization JSONObjectWithData:[aJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&anError];
			
			if (anError != nil) {
				LOG("Parsing the response failed : Error : %@", [anError localizedDescription]);
                LOG("----- responseString = %@", aJsonString);

				
				if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFailWithResponse:)]) {
					[self.delegate requestDidFailWithResponse:anError];
				}
				
				[self purgeRequest];
			} else {
				if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidSucceedWithResponse:)]) {
					[self.delegate requestDidSucceedWithResponse:aResponseDictionary];
				}
			}
		} else {
			if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidSucceedWithResponse:)]) {
				[self.delegate requestDidSucceedWithResponse:aResponseDictionary];
			}
		}
	}
}


- (void)purgeRequest {
	// Cancel the request
	[self.dataTask cancel];

	// Reset the timer
	[self.requestTimer invalidate];
	self.requestTimer = nil;
	
	// Clear the response data.
	self.responseData = [NSMutableData dataWithLength:0];
}


#pragma mark - Request Timer

- (void)setupRequestTimer {
	self.requestTimer = [NSTimer timerWithTimeInterval:kServiceRequestTimeOutInSeconds target:self selector:@selector(requestDidTimeOut) userInfo:nil repeats:NO];
}


- (void)requestDidTimeOut {
	[self purgeRequest];
}


#pragma mark - NSURLSessionData Delegates

- (void)URLSession:(NSURLSession *)iSession dataTask:(NSURLSessionDataTask *)iDataTask didReceiveResponse:(NSURLResponse *)iResponse completionHandler:(void (^)(NSURLSessionResponseDisposition iDisposition))iCompletionHandler {
	iCompletionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)iSession dataTask:(NSURLSessionDataTask *)iDataTask didReceiveData:(NSData *)iData {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.requestTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kServiceRequestTimeOutInSeconds]];
		[self.responseData appendData:iData];
	});
}


#pragma mark - NSURLSessionTask Delegates

- (void)URLSession:(NSURLSession *)iSession task:(NSURLSessionTask *)iTask didCompleteWithError:(NSError *)iError {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (iError) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFailWithResponse:)]) {
                [self.delegate requestDidFailWithResponse:iError];
            }
            
            if ( self.completionBlock != nil) {
                self.completionBlock(nil,iTask.response,iError);
            }
            
            [self purgeRequest];
        } else {
            // Task completed succesfully. Now parse the response.
            [self parseResponse];
        }
    });
}


- (void)URLSession:(NSURLSession *)iSession task:(NSURLSessionTask *)iTask didReceiveChallenge:(NSURLAuthenticationChallenge *)iChallenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition iDisposition, NSURLCredential *iCredential))iCompletionHandler {
	[[TPMGAuthenticationChallengeHandler sharedAuthenticationChallengeHandler] handleAuthenticationChallenge:iChallenge];
}


#pragma mark - NSURLSession Delegate

- (void)URLSession:(NSURLSession *)iSession didBecomeInvalidWithError:(NSError *)iError {
	if (iError) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidFailWithResponse:)]) {
			[self.delegate requestDidFailWithResponse:iError];
		}
		
		[self purgeRequest];
	}
}


- (void)URLSession:(NSURLSession *)iSession didReceiveChallenge:(NSURLAuthenticationChallenge *)iChallenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition iDisposition, NSURLCredential *iCredential))iCompletionHandler {
	[[TPMGAuthenticationChallengeHandler sharedAuthenticationChallengeHandler] handleAuthenticationChallenge:iChallenge];
}

#pragma Download Delegate

#pragma mark - Download Task Delegates

- (void)URLSession:(NSURLSession *)iSession downloadTask:(NSURLSessionDownloadTask *)iDownloadTask didFinishDownloadingToURL:(NSURL *)iLocation {
    NSData *iData = [NSData dataWithContentsOfURL:iLocation];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completionBlock) {
            self.completionBlock(iData,iDownloadTask.response,nil);
        }
    });
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    dispatch_async(dispatch_get_main_queue(), ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"BackgroundSessionCompletionHandler" object:nil];
    });
    
}






@end
