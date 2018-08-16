//
//  TPMGAuthenticationChallengeHandler.m
//  KaiserPermanente
//
//  Created by Jak Jonnalagadda on 4/3/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAuthenticationChallengeHandler.h"
#import <Security/Security.h>
#import "TPMGServiceConstants.h"


@implementation TPMGAuthenticationChallengeHandler


#pragma mark - Shared Instance

+ (TPMGAuthenticationChallengeHandler *)sharedAuthenticationChallengeHandler {
	static dispatch_once_t singleton_queue;
	static TPMGAuthenticationChallengeHandler *challengeHandler = nil;

	dispatch_once(&singleton_queue, ^{
		challengeHandler = [[TPMGAuthenticationChallengeHandler alloc] init];
	});

	return challengeHandler;
}


#pragma mark - Lifecycle

- (id)init {
	self = [super init];

	if (self) {
	}

	return self;
}


- (void)handleAuthenticationChallenge:(NSURLAuthenticationChallenge *)iChallenge {
	OSStatus                err;
	NSURLProtectionSpace   *protectionSpace;
	SecTrustRef             trust;
	BOOL                    trusted;
	SecTrustResultType      trustResult;

	if (iChallenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
		protectionSpace = [iChallenge protectionSpace];
		assert(protectionSpace != nil);
		
		trust = [protectionSpace serverTrust];
		assert(trust != NULL);
		
		// Evaluate the trust the standard way.
		
		err = SecTrustEvaluate(trust, &trustResult);
		trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified));
		
		if (trusted) {
			[iChallenge.sender useCredential:[NSURLCredential credentialForTrust:iChallenge.protectionSpace.serverTrust] forAuthenticationChallenge:iChallenge];
		} else {
			[iChallenge.sender cancelAuthenticationChallenge:iChallenge];
		}
		
		return;
	}

	[iChallenge.sender performDefaultHandlingForAuthenticationChallenge:iChallenge];
}

- (BOOL)validateServiceEnvironment:(NSString *)iCertificateSummary {
    //TODO: Uncomment the environment string and pass the right value. This is currently commented as it is not in use.
    if (/* DISABLES CODE */ (YES)/*[[[Utilities getAppDel] getAppEnvironmentAsString] isEqualToString:@"LIVE"]*/) {
        if ([iCertificateSummary rangeOfString:@"api.kaiserpermanente.org"].length == NSNotFound || [iCertificateSummary rangeOfString:@"kaiser permanente"].length == NSNotFound) {
            return NO;
        }
    } else {
        if ([iCertificateSummary rangeOfString:@"kaiserpermanente.org"].length == NSNotFound) {
            return NO;
        }
    }
    
    return YES;
}


// Optional technique to validate hostname.  Instead of using SecCertificateCopySubjectSummary
// use SecPolicyCreateSSL to create a server policy with the specified name,
// then crreate a trust, run SecTrustEvaluate and determine status
//
//  SecCertificateCopySubjectSummary is not well documented what this will return
//  It currently returns all Common Names separated by commas
//  Is better to run through SecTrustEvaluate
//  This method was pulled  from a branch and has not been tested here
//

- (BOOL)validateHostNameWithPolicyEvaluation:(NSString *)iHostname ofChallenge:(NSURLAuthenticationChallenge *)iChallenge {
	BOOL result = NO;

	OSStatus                err;
	NSURLProtectionSpace   *protectionSpace;
	SecTrustRef             trust;
	SecTrustResultType      trustResult;

	protectionSpace = [iChallenge protectionSpace];
	assert(protectionSpace != nil);

	trust = [protectionSpace serverTrust];
	assert(trust != NULL);

	// Evaluate the trust the standard way.

	err = SecTrustEvaluate(trust, &trustResult);
    if (err != 0) {
        LOG("SecTrustEvaluate result = %d", (int)err);
    }
	CFIndex trustCertificateCount = SecTrustGetCertificateCount(iChallenge.protectionSpace.serverTrust);

	NSMutableArray *trustCertificates = [[NSMutableArray alloc] initWithCapacity:trustCertificateCount];
	
	for (int i = 0; i < trustCertificateCount; i++) {
		SecCertificateRef trustCertificate =  SecTrustGetCertificateAtIndex(iChallenge.protectionSpace.serverTrust, i);
		[trustCertificates addObject:(__bridge id) trustCertificate];
	}

	CFStringRef searchName = (__bridge CFStringRef)(iHostname);
	SecPolicyRef policyRef = SecPolicyCreateSSL(YES,  searchName);

	SecTrustCreateWithCertificates((__bridge CFArrayRef) trustCertificates, policyRef, &trust);
	err = SecTrustEvaluate(trust, &trustResult);
	
	if (err == errSecSuccess) {
		// expect trustResultType == kSecTrustResultUnspecified
		if (trustResult == kSecTrustResultUnspecified) {
			LOG("Unspecified - We can trust this certificate!");
			result = YES;
		} else if (trustResult == kSecTrustResultProceed) {
			LOG("Proceed - We can trust this certificate!");
			result = YES;
		}
	} else {
		LOG("Creating trust failed: %d",(int)err);
	}

	if (policyRef) {
		CFRelease(policyRef);
	}

	return result;
}


@end
