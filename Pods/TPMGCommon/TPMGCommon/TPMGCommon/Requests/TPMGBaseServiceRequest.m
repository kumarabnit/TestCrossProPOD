//
//  TPMGBaseServiceRequest.m
//  TPMGCommon
//
//  Created by GK on 5/20/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGBaseServiceRequest.h"


@implementation TPMGBaseServiceRequest


#pragma mark - Initializer

- (id)init {
	self = [super init];
	
	if (self) {
        // Additional initalization here.
	}
	
	return self;
}


#pragma mark - Private Methods.

- (NSMutableURLRequest *)createHeaderForRequest:(NSMutableURLRequest *)iRequestURL {
	if (self.requestHeaders && [self.requestHeaders count] > 0) {
		NSArray *aHeaderKeyList = [self.requestHeaders allKeys];
		
		for (NSString *aKey in aHeaderKeyList) {
			[iRequestURL setValue:[self.requestHeaders valueForKey:aKey] forHTTPHeaderField:aKey];
		}
	}
	
	return iRequestURL;
}


- (NSMutableURLRequest *)createBodyForRequest:(NSMutableURLRequest *)iRequestURL {
    if (self.requestBody) {
        NSArray *aListOfKeys = [self.requestBody allKeys];
        NSString *aBodyString = nil;
        
        for (NSString *aBodyKey in aListOfKeys) {
            if (!aBodyString) {
                aBodyString = [NSString stringWithFormat:@"%@=%@", aBodyKey, [self.requestBody valueForKey:aBodyKey]];
            } else {
                aBodyString = [aBodyString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", aBodyKey, [self.requestBody valueForKey:aBodyKey]]];
            }
        }
        
        [iRequestURL setHTTPBody:[aBodyString dataUsingEncoding:NSUTF8StringEncoding]];
        LOG("Request: %@?%@", iRequestURL.URL, aBodyString);
    } else if (self.JSONBody != nil) {
        [iRequestURL setHTTPBody:[self.JSONBody dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return iRequestURL;
}


- (NSMutableURLRequest *)generateRequestWithURL:(NSURL *)iRequestURL {
	NSMutableURLRequest *aNetworkRequest = [[NSMutableURLRequest alloc] init];
    [aNetworkRequest setURL:iRequestURL];
    [aNetworkRequest setHTTPMethod:self.requestHTTPMethod];
	[aNetworkRequest setTimeoutInterval:kServiceRequestTimeOutInSeconds];
	
	aNetworkRequest = [self createHeaderForRequest:aNetworkRequest];
	aNetworkRequest = [self createBodyForRequest:aNetworkRequest];
	
	return aNetworkRequest;
}

@end
