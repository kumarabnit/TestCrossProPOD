//
//  TPMGCookieManager.m
//  TPMGCommon
//
//  Created by GK on 6/26/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGCookieManager.h"


@implementation TPMGCookieManager


#pragma mark - Cookie Creation

+ (void)createCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieDomain path:(NSString *)iCookiePath expiryDate:(NSDate *)iCookieExpiryDate {
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

	NSMutableDictionary *theCookieProperties = [NSMutableDictionary dictionary];
	[theCookieProperties setObject:iCookieName forKey:NSHTTPCookieName];
	[theCookieProperties setObject:iCookieValue forKey:NSHTTPCookieValue];
	[theCookieProperties setObject:iCookieDomain forKey:NSHTTPCookieDomain];
	[theCookieProperties setObject:iCookiePath forKey:NSHTTPCookiePath];
	[theCookieProperties setObject:iCookieExpiryDate forKey:NSHTTPCookieExpires];
	[theCookieProperties setObject:@"TRUE" forKey:NSHTTPCookieSecure];

	NSHTTPCookie *aNewCookie = [NSHTTPCookie cookieWithProperties:theCookieProperties];
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:aNewCookie];
}


+ (void)createCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieDomain path:(NSString *)iCookiePath expiryDate:(NSDate *)iCookieExpiryDate secure:(NSString *)iCookieSecure {
    
    NSMutableDictionary *theCookieProperties = [NSMutableDictionary dictionary];
    [theCookieProperties setObject:iCookieName forKey:NSHTTPCookieName];
    [theCookieProperties setObject:iCookieValue forKey:NSHTTPCookieValue];
    [theCookieProperties setObject:iCookieDomain forKey:NSHTTPCookieDomain];
    [theCookieProperties setObject:iCookiePath forKey:NSHTTPCookiePath];
    [theCookieProperties setObject:iCookieExpiryDate forKey:NSHTTPCookieExpires];
    [theCookieProperties setObject:iCookieSecure forKey:NSHTTPCookieSecure];
    
    NSHTTPCookie *aNewCookie = [NSHTTPCookie cookieWithProperties:theCookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:aNewCookie];
    
}

+ (NSHTTPCookie *)createSSOInterruptCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieDomain path:(NSString *)iCookiePath expiryDate:(NSDate *)iCookieExpiryDate  secure:(NSString *)iCookieSecure {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSMutableDictionary *theCookieProperties = [NSMutableDictionary dictionary];
    [theCookieProperties setObject:iCookieName forKey:NSHTTPCookieName];
    [theCookieProperties setObject:iCookieValue forKey:NSHTTPCookieValue];
    [theCookieProperties setObject:iCookieDomain forKey:NSHTTPCookieDomain];
    [theCookieProperties setObject:iCookiePath forKey:NSHTTPCookiePath];
    [theCookieProperties setObject:iCookieExpiryDate forKey:NSHTTPCookieExpires];
    [theCookieProperties setObject:@"TRUE" forKey:NSHTTPCookieSecure];
    
    NSHTTPCookie *aNewCookie = [NSHTTPCookie cookieWithProperties:theCookieProperties];
    return aNewCookie;
}

#pragma mark - Cookie Deletion

+ (void)deleteCookieWithName:(NSString *)iCookieName {
	NSArray *aListOfCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

	for (NSHTTPCookie *aCookie in aListOfCookies) {
		if ([aCookie.name isEqualToString:iCookieName]) {
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:aCookie];
			break;
		}
	}
}


+ (void)deleteAllCookies {
	NSArray *aListOfCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	
	for (NSHTTPCookie *aCookie in aListOfCookies) {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:aCookie];
	}
}


#pragma mark - Fetch cookie

+ (NSHTTPCookie *)fetchCookieWithName:(NSString *)iCookieName {
	NSHTTPCookie *aCookieToReturn = nil;
	NSArray *aCookieList = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

	for (NSHTTPCookie *aCookie in aCookieList) {
		if ([[aCookie name] isEqualToString:iCookieName]) {
			aCookieToReturn = aCookie;
		}
	}
	
	return aCookieToReturn;
}


@end
