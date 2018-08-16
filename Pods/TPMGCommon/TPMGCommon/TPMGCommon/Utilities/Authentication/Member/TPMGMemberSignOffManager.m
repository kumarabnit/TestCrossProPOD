//
//  TPMGMemberSignOffManager.m
//  TPMGCommon
//
//  Created by GK on 6/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGMemberSignOffManager.h"


@interface TPMGMemberSignOffManager ()

@property (nonatomic, strong) NSString *APIKey;
@property (nonatomic, strong) NSString *SSOSession;
@property (nonatomic, strong) NSString *appName;

@end

@implementation TPMGMemberSignOffManager


#pragma mark - Sign off

+ (void)signOffUserWithURL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	TPMGMemberSignOffManager *aSignOffManager = [[[self class] alloc] init];
	[aSignOffManager processParameters:iParameters];
	
	[TPMGServiceManager sendAsynchronousRequestWithURL:iURL method:iHTTPMethod body:nil header:[aSignOffManager headerParameters] completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
		if (iError) {
            // Calling the main thread to perform the operation
            [aSignOffManager signOffDidFailWithError:iError completionBlock:iCompletionBlock];
        } else {
			[aSignOffManager signOffDidSucceedWithResponse:(NSURLResponse *)iResponse data:(NSData *)iData completionBlock:iCompletionBlock];
        }
	}];
}

	 
#pragma mark - Private Methods.
	 
- (void)processParameters:(NSDictionary *)iParameterDictionary {
	self.APIKey = [iParameterDictionary objectForKey:kSignOnAPIKey];
	self.SSOSession = [iParameterDictionary objectForKey:kSignOnSSOSession];
	self.appName = [iParameterDictionary objectForKey:kSignOnAppName];
}


- (NSDictionary *)headerParameters {
    NSMutableDictionary *aHeaderDictionary = [NSMutableDictionary dictionary];
	[aHeaderDictionary setObject:@"I" forKey:kRequestHeaderKeyUserAgentCategory];
	[aHeaderDictionary setObject:[[UIDevice currentDevice] systemVersion] forKey:kRequestHeaderKeyOSVersion];
    [aHeaderDictionary setObject:[TPMGServiceManager getHWString] forKey:kRequestHeaderKeyUserAgentType];
	[aHeaderDictionary setObject:self.APIKey forKey:kRequestHeaderAPIKey];
	[aHeaderDictionary setObject:self.appName forKey:kRequestHeaderKeyAppName];
	[aHeaderDictionary setObject:self.SSOSession forKey:kRequestHeaderKeyssosession];
	
    return aHeaderDictionary;
}


- (void)signOffDidFailWithError:(NSError *)iError completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	NSDictionary *aErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];
    
	if (iCompletionBlock) {
		iCompletionBlock(NO, aErrorDictionary);
	}
}


- (void)signOffDidSucceedWithResponse:(NSURLResponse *)iResponse data:(NSData *)iResponseData completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    NSString *aRelationID = nil;
    
    // Printing the header values
    NSHTTPURLResponse *aHTTPResponse = (NSHTTPURLResponse *)iResponse;
    
	if ([aHTTPResponse respondsToSelector:@selector(allHeaderFields)]) {
		NSDictionary *aHeaderDictionary = [aHTTPResponse allHeaderFields];
        aRelationID = [aHeaderDictionary objectForKey:kResponseKeyXCorrelationID];
	}
    
    if (aRelationID && [aRelationID length] > 0) {
        // Building success data dictionary containing ssosession and User values as keys and corresponding values as objects
        NSMutableDictionary *aResponseDictionary = [NSMutableDictionary dictionary];
        [aResponseDictionary setObject:aRelationID forKey:kResponseKeyCorrelationID];
        
		if (iCompletionBlock) {
			iCompletionBlock(YES, aResponseDictionary);
		}
    } else {
		NSDictionary *aErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];
		
		if (iCompletionBlock) {
			iCompletionBlock(NO, aErrorDictionary);
		}
    }
}

@end
