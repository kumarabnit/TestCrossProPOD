//
//  TPMGServiceReachability.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceReachability.h"
#import "TPMGReachability.h"

@interface TPMGServiceReachability ()

@property (nonatomic) TPMGReachability *internetReachability;
@property (nonatomic) TPMGReachability *wifiReachability;

@end


@implementation TPMGServiceReachability


#pragma mark - Initializer

- (id)init {
	self = [super init];
	
	if (self) {
		[self setupReachability];
	}
	
	return self;
}


- (void)setupReachability {
#if !TARGET_IPHONE_SIMULATOR
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
#endif
	
	self.internetReachability = [TPMGReachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	
    self.wifiReachability = [TPMGReachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
}


#pragma mark - Service availability

- (BOOL)isServiceAvailable {
	BOOL isServiceAvailable = NO;
	
	NetworkStatus anInternetNetworkStatus = [self.internetReachability currentReachabilityStatus];
	NetworkStatus aWiFiNetworkStatus = [self.wifiReachability currentReachabilityStatus];

	if (anInternetNetworkStatus == ReachableViaWWAN || aWiFiNetworkStatus == ReachableViaWiFi) {
		isServiceAvailable = YES;
	}

	return isServiceAvailable;
}


#pragma mark - Notification Handler

- (void)reachabilityChanged:(NSNotification *)iNotification {
	if (iNotification) {
		TPMGReachability *aCurrentReachability = [iNotification object];
		
		if ([aCurrentReachability isKindOfClass:[TPMGReachability class]]) {
			if (aCurrentReachability == self.internetReachability || aCurrentReachability == self.wifiReachability) {
				if (self.delegate && [self.delegate respondsToSelector:@selector(networkReachabilityDidChange)]) {
					[self.delegate networkReachabilityDidChange];
				}
			}
		}
	}
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kReachabilityChangedNotification object:nil];
}

@end
