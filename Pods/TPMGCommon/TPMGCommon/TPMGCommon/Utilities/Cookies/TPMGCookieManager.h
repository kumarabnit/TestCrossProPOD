//
//  TPMGCookieManager.h
//  TPMGCommon
//
//  Created by GK on 6/26/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface TPMGCookieManager : NSObject

// This API creates a new cookie with the given properties.
+ (void)createCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieValue path:(NSString *)iCookieString expiryDate:(NSDate *)iCookieExpiryDate;

+ (void)createCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieDomain path:(NSString *)iCookiePath expiryDate:(NSDate *)iCookieExpiryDate secure:(NSString *)iCookieSecure;

+ (NSHTTPCookie *)createSSOInterruptCookieWithName:(NSString *)iCookieName value:(NSString *)iCookieValue domain:(NSString *)iCookieDomain path:(NSString *)iCookiePath expiryDate:(NSDate *)iCookieExpiryDate secure:(NSString *)iCookieSecure;

// This API deletes the cookie with the given cookie name
+ (void)deleteCookieWithName:(NSString *)iCookieName;

// This API deletes all the cookies
+ (void)deleteAllCookies;

// This API fetches the cookie with the given name
+ (NSHTTPCookie *)fetchCookieWithName:(NSString *)iCookieName;

@end
