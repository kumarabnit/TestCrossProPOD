//
//  TPMGServiceSession.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceSession.h"


static TPMGServiceSession *sharedSession;
static dispatch_once_t oncePredicate;

@implementation TPMGServiceSession

/*!
 @method sharedServiceSession
 @abstract This method is called to obtain a shared singleton instance of session variables and flags.
 @return TPMGServiceSession Shared Singleton instance
 */

+ (TPMGServiceSession *)sharedServiceSession {
	dispatch_once(&oncePredicate, ^{
		sharedSession = [[TPMGServiceSession alloc] init];
	});

	return sharedSession;
}


@end
