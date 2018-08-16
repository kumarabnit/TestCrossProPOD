//
//  TPMGMemberSignOnManager.m
//  TPMGCommon
//
//  Created by GK on 6/17/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGMemberSignOnManager.h"
#import "NSData+Additions.h"


@interface TPMGMemberSignOnManager ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *APIKey;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVersion;

@end

@implementation TPMGMemberSignOnManager


#pragma mark - Sign On

+ (void)authenticateUserWithURL:(NSURL *)iAuthenticationURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	TPMGMemberSignOnManager *aSignOnManager = [[[self class] alloc] init];
	[aSignOnManager processParameters:iParameters];
	
	[TPMGServiceManager sendAsynchronousRequestWithURL:iAuthenticationURL method:iHTTPMethod body:nil header:[aSignOnManager headerParameters] completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        if (iError) {
            NSHTTPURLResponse *anHTTPURLResponse = (NSHTTPURLResponse *)iResponse;
            if ([anHTTPURLResponse statusCode] == 302 || [anHTTPURLResponse statusCode] == 401) {
                [aSignOnManager authenticationDidSucceedWithData:iData response:iResponse completionBlock:iCompletionBlock];
            } else {
                [aSignOnManager authenticationDidFail:iError response:(NSURLResponse *)iResponse data:(NSData *)iData completionBlock:iCompletionBlock];
            }
        } else {
			[aSignOnManager authenticationDidSucceedWithData:iData response:iResponse completionBlock:iCompletionBlock];
		}
	}];
}


+ (void)authenticateUserWithURL:(NSURL *)iAuthenticationURL systemStatusCheckURL:(NSURL *)iSystemStatusCheckURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	[[self class] checkSystemStatusWithURL:iSystemStatusCheckURL method:iHTTPMethod parameters:iParameters completionBlock:^(BOOL iSucceeded, id iResponseObject) {
		if (iSucceeded) {
			[[self class] authenticateUserWithURL:iAuthenticationURL method:iHTTPMethod parameters:iParameters completionBlock:iCompletionBlock];
		} else {
			if (iCompletionBlock) {
				iCompletionBlock(iSucceeded, iResponseObject);
			}
		}
	}];
}


+ (void)checkSystemStatusWithURL:(NSURL *)iSystemStatusCheckURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	TPMGMemberSignOnManager *aSignOnManager = [[[self class] alloc] init];
	[aSignOnManager processParameters:iParameters];
	
	[TPMGServiceManager sendAsynchronousRequestWithURL:iSystemStatusCheckURL method:iHTTPMethod body:[aSignOnManager bodyParameters] header:nil completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
		if (iError) {
			[aSignOnManager systemStatusCheckDidFail:iError completionBlock:iCompletionBlock];
		} else {
			[aSignOnManager systemStatusCheckDidSucceedWithData:iData response:iResponse completionBlock:iCompletionBlock];
		}
	}];
}


#pragma mark - Initializer

- (id)init {
	if (self = [super init]) {
		
	}
	
	return self;
}


#pragma mark - Private Methods.

- (void)processParameters:(NSDictionary *)iParameterDictionary {
	self.username = [iParameterDictionary valueForKey:kSignOnUserName];
	self.password = [iParameterDictionary valueForKey:kSignOnPassword];
	self.region = [iParameterDictionary valueForKey:kSignOnRegion];
	self.APIKey = [iParameterDictionary valueForKey:kSignOnAPIKey];
	self.appID = [iParameterDictionary valueForKey:kSignOnAppID];
	self.appName = [iParameterDictionary valueForKey:kSignOnAppName];
	self.appVersion = [iParameterDictionary valueForKey:kSignOnAppVersion];
}


- (NSString *)fetchSSOSessionObjectFromURLResponse:(NSURLResponse *)iURLResponse {
    // Obtaining first the header field dictionary from httpResponse and obtaining value of ssosession from dictionary
    NSString *aSSOsession = nil;
    NSHTTPURLResponse *aHTTPResponse = (NSHTTPURLResponse *)iURLResponse;
    
	if ([aHTTPResponse respondsToSelector:@selector(allHeaderFields)]) {
		NSDictionary *theHeaderFields = [aHTTPResponse allHeaderFields];
        aSSOsession = [theHeaderFields objectForKey:kRequestHeaderKeyssosession];
        if (aSSOsession == nil) {
            aSSOsession = [theHeaderFields objectForKey:kRequestHeaderKeySessionToken];
        }
	}
    
    return aSSOsession;
}

-(NSDictionary *)fetchHeadersFromURLResponse:(NSURLResponse *)iURLResponse {
    NSHTTPURLResponse *aHTTPResponse = (NSHTTPURLResponse *)iURLResponse;
    NSDictionary *theHeaderFields = [[NSDictionary alloc]init];
    if([aHTTPResponse respondsToSelector:@selector(allHeaderFields)]) {
        theHeaderFields = [aHTTPResponse allHeaderFields];
    }
    return theHeaderFields;
}

- (NSInteger)statusCodeForResponse:(NSDictionary *)iResponseDictionary {
	NSInteger aStatusCode = 20;
    id aFailureInfoDictionary = [iResponseDictionary objectForKey:kResponseKeyFailureInfo];
    
    //KEEPING THE BELOW TWO CONDITIONS TO SUPPORT V1.1 SIGN-ON URLS, ONCE BACKEND IS STABLE FOR V2.O WILL REMOVE IT
    
    // If account locked is there and true and if user is null, status code = 6
    if ([iResponseDictionary objectForKey:kResponseKeyAccountLocked] && [[iResponseDictionary objectForKey:kResponseKeyAccountLocked] boolValue] == true && ![iResponseDictionary objectForKey:kResponseKeyUser]) {
        aStatusCode = 6;
    }
    // If authentication failed is there are true and if user is null, status code = 5
    else if ([iResponseDictionary objectForKey:kResponseKeyAuthenticationFailed] && [[iResponseDictionary objectForKey:kResponseKeyAuthenticationFailed] boolValue] == true && ![iResponseDictionary objectForKey:kResponseKeyUser]) {
        aStatusCode = 5;
    }
    //TODO: NEED TO REMOVE THE ABOVE TWO CONDITIONS ONCE BACKEND IS STABLE FOR V2.O SIGN-ON URLS
    
    else if ([aFailureInfoDictionary isKindOfClass:[NSDictionary class]] && ![aFailureInfoDictionary isEqual:[NSNull null]] && [aFailureInfoDictionary objectForKey:kResponseKeyAccountLocked] && [[aFailureInfoDictionary objectForKey:kResponseKeyAccountLocked] boolValue]) {
        // If account locked key is present and it is 'Y' and if user is null, status code = 6
        aStatusCode = 6;
    }
    else if ([aFailureInfoDictionary isKindOfClass:[NSDictionary class]] && ![aFailureInfoDictionary isEqual:[NSNull null]] && [aFailureInfoDictionary objectForKey:kResponseKeyAuthenticationFailed] && [[aFailureInfoDictionary objectForKey:kResponseKeyAuthenticationFailed] boolValue]) {
		// If authentication failed key is present and it is 'Y' and if user is null, status code = 5
		aStatusCode = 5;
	} else if ([iResponseDictionary objectForKey:kResponseKeySystemError] && [iResponseDictionary objectForKey:kResponseKeySystemError] != [NSNull null]) {
		// If system error key is present and it is not null, status code = 20
		aStatusCode = kErrorCodeGeneric;
	} else if ([iResponseDictionary objectForKey:kResponseKeyUser] && [iResponseDictionary objectForKey:kResponseKeyUser] != [NSNull null]) {
		// Obtaining dictionary from User tag
		NSDictionary *aUserDictionary = [iResponseDictionary objectForKey:kResponseKeyUser];
        
        NSString *businessErrStr=[iResponseDictionary objectForKey:kResponseKeyBussinessError];
        NSString *anEBizAccountRoleString=nil;
        NSString *userActivationStatusCodeString = nil;
        
        if (aUserDictionary!=nil) {
            id anEBizAccountRoles = [aUserDictionary objectForKey:kResponseKeyEBizAccountRoles];
            
            if (anEBizAccountRoles && [anEBizAccountRoles isKindOfClass:[NSArray class]]) {
                 anEBizAccountRoleString= [anEBizAccountRoles componentsJoinedByString:@","];
            }
            
            userActivationStatusCodeString = [aUserDictionary objectForKey:kActivatinStatusCode];
        }
        
        // If region is not the region passed by client, status code = 8
        BOOL isRegionSupported = true;
        if ([[aUserDictionary objectForKey:kResponseKeyRegion] isEqualToString:self.region] == false) {
            isRegionSupported = false;
            //MyMeds supports both MRN and MID accounts hence making one more check for MID
            if ([self.appName isEqualToString:kMMAPPNAME] && [[aUserDictionary objectForKey:kResponseKeyRegion] isEqualToString:kMIDREGION]) {
                isRegionSupported = true;
            }
        }
        
		if (isRegionSupported == false) {
			aStatusCode = 8;
		} else if (([iResponseDictionary objectForKey:kResponseKeySystemError] && [iResponseDictionary objectForKey:kResponseKeySystemError] == [NSNull null] && [iResponseDictionary objectForKey:kResponseKeyBussinessError] && [iResponseDictionary objectForKey:kResponseKeyBussinessError] == [NSNull null]) || ([businessErrStr isEqualToString:@"INVALID_MEMBERSHIP_STATUS"] && [anEBizAccountRoleString isEqualToString:@"UNM"])) {
			
			// if interrupt error is there and it is NOT null
			if ([iResponseDictionary objectForKey:kResponseKeyInterrupt] && [iResponseDictionary objectForKey:kResponseKeyInterrupt] != [NSNull null]) {
				// Obtaining interrupt array from interrupt tag
				NSArray *interruptArray = [iResponseDictionary objectForKey:kResponseKeyInterrupt];
				
				// If interrupt array contains UNABLE_TO_ACTIVATE_MYCHART_ACCOUNT, status code = 7
				if ([interruptArray containsObject:kResponseKeyUnableToActivateMychartAccount]) {
					aStatusCode = 7;
                } else if ([interruptArray containsObject:kSSOIterruptTNCMustAcceptNewVersion] || [interruptArray containsObject:kSSOIterruptTNCNotAccepted] || [interruptArray containsObject:kSSOIterruptTNC365] || [interruptArray containsObject:kSSOIterruptTempPassword] || [interruptArray containsObject:kSSOIterruptEmailMismatch] || [interruptArray containsObject:kSSOIterruptSecretQuestions]) {
                    aStatusCode = kInterruptStatusCode;
                } else {
                    aStatusCode = 0;
                }
            } else {
                aStatusCode = 0;
            }
		} else if ([iResponseDictionary objectForKey:kResponseKeyBussinessError] && [iResponseDictionary objectForKey:kResponseKeyBussinessError] != NULL) {
            // If business error is MEMBERSHIP_TERMINATED, status code = 9
            if ([[iResponseDictionary objectForKey:kResponseKeyBussinessError] caseInsensitiveCompare:@"MEMBERSHIP_TERMINATED"] == NSOrderedSame) {
                aStatusCode = 9;
            } else if ([[iResponseDictionary objectForKey:kResponseKeyBussinessError] caseInsensitiveCompare:@"INVALID_ACTIVATION_STATUS"] == NSOrderedSame && [userActivationStatusCodeString caseInsensitiveCompare:@"PENDOTP"] == NSOrderedSame) {
                // If business error is INVALID_ACTIVATION_STATUS and activationStatusCode is PENDOTP, status code = 12
                aStatusCode = 12;
            } else {
                // If business error and it is not null and it is not UNM for NMA account, status code = 7
                aStatusCode = 7;
            }

		} else {
			aStatusCode = kErrorCodeGeneric;
		}
	} else if ([iResponseDictionary objectForKey:kResponseKeySuccess] && ![[iResponseDictionary objectForKey:kResponseKeySuccess] boolValue]) {
		id aFailureInfo = [iResponseDictionary objectForKey:kResponseKeyFailureInfo];

		if (aFailureInfo) {
			if ([[aFailureInfo objectForKey:kResponseKeyUnauthorized] boolValue] && [[aFailureInfo stringForKey:kResponseKeyErrorCode] isEqualToString:@"D1000"]) {
				aStatusCode = 1000;
			}
		}
	}
	
	return aStatusCode;
}


- (void)authenticationDidSucceedWithData:(NSData *)iResponseData response:(NSURLResponse *)iResponse completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	// Printing the repsonse string
	LOG("Response Data :\n%@", [[NSString alloc] initWithBytes:[iResponseData bytes] length:[iResponseData length] encoding:NSUTF8StringEncoding]);

	// Parsing the data
	NSError *anError = nil;
	NSDictionary *aResponseDictionary = [NSJSONSerialization JSONObjectWithData:iResponseData options:NSJSONReadingMutableContainers error:&anError];

	if (!anError) {
		// Printing the data
		LOG("Parsed Data :\n%@", [aResponseDictionary description]);

		// Calling method to decide that status code based on some conditions
		NSInteger aStatusCode = [self statusCodeForResponse:aResponseDictionary];
		
		// If status code is 0, then it is SUCCESS, else for any other status code, it is FAILURE
		if (aStatusCode == 0) {
			NSMutableDictionary *aResponse = [NSMutableDictionary dictionaryWithDictionary:aResponseDictionary];
		
			// Obtaining SSOSession object from the NSURLResponse
			NSString *aSSOSessionString = [self fetchSSOSessionObjectFromURLResponse:iResponse];
			
			[aResponse setValue:[NSNumber numberWithInteger:0] forKey:@"statusCode"];
			[aResponse setValue:@"Success" forKey:kResponseKeyStatusTitle];
			[aResponse setValue:@"Success" forKey:kResponseKeyStatusMessage];
			[aResponse setValue:aSSOSessionString forKey:kResponseKeySSOSession];
			
            if (aSSOSessionString && ([aSSOSessionString isEqual:[NSNull null]] == NO) && aSSOSessionString.length > 0){
                id aResponseUserKeyValue = [aResponseDictionary objectForKey:kResponseKeyUser];
                
                if (aResponseUserKeyValue != [NSNull null]) {
                    id anEBizAccountRoles = [aResponseUserKeyValue objectForKey:kResponseKeyEBizAccountRoles];
                    
                    if (anEBizAccountRoles && [anEBizAccountRoles isKindOfClass:[NSArray class]]) {
                        NSString *anEBizAccountRoleString = [anEBizAccountRoles componentsJoinedByString:@","];
                        [aResponse setValue:anEBizAccountRoleString forKey:kResponseKeyEBizAccountRoles];
                    }
                }
                
                // Passing the response dictionary back to the calling success block
                if (iCompletionBlock) {
                    iCompletionBlock(YES, aResponse);
                }
            } else {
                NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];
                
                if (iCompletionBlock) {
                    iCompletionBlock(NO, anErrorDictionary);
                }
            }
        } else if (aStatusCode == kInterruptStatusCode) {
            NSMutableDictionary *interruptResponseDictionary = [NSMutableDictionary dictionary];
            [interruptResponseDictionary setObject:[self fetchHeadersFromURLResponse:iResponse] forKey:kInterruptHeaderResponse];
            [interruptResponseDictionary setObject:aResponseDictionary forKey:kInterruptBodyResponse];
            [interruptResponseDictionary setObject:@"true" forKey:kIsInterruptDictionary];
            iCompletionBlock(NO, interruptResponseDictionary);
        } else {
			NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:aStatusCode];

			if (iCompletionBlock) {
				iCompletionBlock(NO, anErrorDictionary);
			}
		}
	} else {
		NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];

		if (iCompletionBlock) {
			iCompletionBlock(NO, anErrorDictionary);
		}
	}
}


- (void)authenticationDidFail:(NSError *)iError response:(NSURLResponse *)iResponse data:(NSData *)iData completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	LOG("Error code : %ld", (long)[iError code]);
    
    NSDictionary *aResponseDictionary = nil;
    
    // If 401, and data is empty, status code = 5, else if data is there, status code = 6
    // If not 401, send generic error code
    if ([iError code] == 401 || [iError code] == -1012) {
        if (iData) {
            NSError *anError = nil;
            aResponseDictionary = [NSJSONSerialization JSONObjectWithData:iData options:NSJSONReadingMutableContainers error:&anError];
            
			NSInteger aStatusCode = [self statusCodeForResponse:aResponseDictionary];
			NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:aStatusCode];
			
			if (iCompletionBlock) {
				iCompletionBlock(NO, anErrorDictionary);
			}
        } else {
			NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:5];
			
			if (iCompletionBlock) {
				iCompletionBlock(NO, anErrorDictionary);
			}
        }
    } else {
		NSDictionary *anErrorDictionary = [self errorResponseForStatusCode:kErrorCodeGeneric];

		if (iCompletionBlock) {
			iCompletionBlock(NO, anErrorDictionary);
		}
    }
}


- (void)systemStatusCheckDidSucceedWithData:(NSData *)iResponseData response:(NSURLResponse *)iResponse completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    // Parsing the data
    NSError *anError = nil;
    NSDictionary *aResponseDictionary = [NSJSONSerialization JSONObjectWithData:iResponseData options:NSJSONReadingMutableContainers error:&anError];
    
    if (!anError) {
        // Printing the data
        LOG("Parsed Data :\n%@", [aResponseDictionary description]);
        
		NSInteger aStatusCode = [[[aResponseDictionary objectForKey:kResponseKey] objectForKey:kResponseKeyStatusCode] integerValue];
		
		if (aStatusCode == 0) {
			if (iCompletionBlock) {
				iCompletionBlock(YES, aResponseDictionary);
			}
		} else {
			if (iCompletionBlock) {
				iCompletionBlock(NO, aResponseDictionary);
			}
		}
	} else {
        if (iCompletionBlock) {
			iCompletionBlock(NO, aResponseDictionary);
		}
    }
}


- (void)systemStatusCheckDidFail:(NSError *)iError completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	if (iCompletionBlock) {
		iCompletionBlock(NO, iError);
	}
}


#pragma mark - Request parameters

- (NSDictionary *)bodyParameters {
	NSMutableDictionary *aBodyParameterDictionary = [NSMutableDictionary dictionary];
	[aBodyParameterDictionary setValue:self.appID forKey:kSignOnAppID];
	[aBodyParameterDictionary setValue:self.appVersion forKey:kSignOnAppVersion];
	[aBodyParameterDictionary setValue:[[UIDevice currentDevice] systemName] forKey:kRequestBodyKeyOS];
	[aBodyParameterDictionary setValue:[[UIDevice currentDevice] systemVersion] forKey:kRequestBodyKeyOSVersion];
	
	return aBodyParameterDictionary;
}


- (NSDictionary *)headerParameters {
	NSMutableDictionary *aHeaderParameterDictionary = [NSMutableDictionary dictionary];
	[aHeaderParameterDictionary setObject:@"I" forKey:kRequestHeaderKeyUserAgentCategory];
	[aHeaderParameterDictionary setObject:[[UIDevice currentDevice] systemVersion] forKey:kRequestHeaderKeyOSVersion];
	[aHeaderParameterDictionary setObject:[TPMGServiceManager getHWString] forKey:kRequestHeaderKeyUserAgentType];
	[aHeaderParameterDictionary setObject:self.APIKey forKey:kRequestHeaderAPIKey];
	[aHeaderParameterDictionary setObject:self.appName forKey:kRequestHeaderKeyAppName];
	[aHeaderParameterDictionary setObject:self.username forKey:kRequestHeaderKeyUserID];
	
	// Creating a plaintext string in the format username:password
	NSString *aLoginString = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
	
	// Employing the Base64 encoding above to encode the authentication tokens
	NSData *anEncodedLoginData = [aLoginString dataUsingEncoding:NSASCIIStringEncoding];
	
	// Creating the contents of the header
	NSString *anAuthenticationHeader = [NSString stringWithFormat:@"Basic %@", [anEncodedLoginData base64EncodedStringWithWrapWidth:80]];
	
	if (anAuthenticationHeader) {
		[aHeaderParameterDictionary setObject:anAuthenticationHeader forKey:kRequestHeaderKeyAuthorization];
	}
	
	return aHeaderParameterDictionary;
}


@end
