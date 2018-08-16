//
//  TPMGMemberKeepAliveManager.m
//  TPMGCommon
//
//  Created by GK on 6/24/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGMemberKeepAliveManager.h"


@interface TPMGMemberKeepAliveManager ()

@property (nonatomic, strong) NSString *SSOSession;
@property (nonatomic, strong) NSString *keepAliveCookieName;

@end

@implementation TPMGMemberKeepAliveManager


#pragma mark - Keep alive

+ (void)renewSSOSession:(NSString *)iSSOSession cookieName:(NSString *)iCookieName URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	TPMGMemberKeepAliveManager *aKeepAliveManager = [[[self class] alloc] init];
	aKeepAliveManager.SSOSession = iSSOSession;
	aKeepAliveManager.keepAliveCookieName = iCookieName;
	
	[TPMGServiceManager sendAsynchronousRequestWithURL:iURL method:iHTTPMethod body:nil header:nil completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
		if (iError) {
			[aKeepAliveManager SSORenewalDidFailWithError:iError response:iResponse data:iData completionBlock:iCompletionBlock];
		} else {
			[aKeepAliveManager SSORenewalDidSucceededWithResponse:iResponse data:iData completionBlock:iCompletionBlock];
		}
	}];
}


#pragma mark - Private Methods

- (void)SSORenewalDidSucceededWithResponse:(NSURLResponse *)iResponse data:(NSData *)iData completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	NSHTTPCookie *aHTTPCookie = nil;
	NSArray *aCookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
		
	for (NSHTTPCookie *aCookie in aCookieArray) {
		if ([[aCookie name] isEqualToString:self.keepAliveCookieName]) {
			aHTTPCookie = aCookie;
		}
	}
		
	NSString *anObSSOSession = [self decodeValueByReplacingPercentEscapes:[aHTTPCookie value]];

	if (iCompletionBlock) {
		iCompletionBlock(YES, anObSSOSession);
	}
}


- (void)SSORenewalDidFailWithError:(NSError *)iError response:(NSURLResponse *)iResponse data:(NSData *)iData completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	NSHTTPURLResponse *aHTTPURLResponse = (NSHTTPURLResponse *)iResponse;
	
	if (![aHTTPURLResponse isKindOfClass:[NSNull class]] && [aHTTPURLResponse statusCode] == 302) {
		[self SSORenewalDidSucceededWithResponse:iResponse data:iData completionBlock:iCompletionBlock];
	} else {
		NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];
		
		if (iCompletionBlock) {
			iCompletionBlock(NO, anErrorDictionary);
		}
	}
}


@end
