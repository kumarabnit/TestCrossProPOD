//
//  TPMGServiceReachability.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@protocol TPMGServiceReachabilityDelegate <NSObject>

// This delegate notifies that the network reachability changed.
- (void)networkReachabilityDidChange;

@end


@interface TPMGServiceReachability : NSObject

@property (unsafe_unretained) id<TPMGServiceReachabilityDelegate> delegate;

- (BOOL)isServiceAvailable;

@end
