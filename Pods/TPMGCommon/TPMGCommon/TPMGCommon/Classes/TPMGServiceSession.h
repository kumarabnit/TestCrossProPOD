//
//  TPMGServiceSession.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

/* This will be a SINGLETON USED WITHIN THE COMMON MODULE ONLY.
   The parameters that need to be retained during a session will go into this.
 */

@interface TPMGServiceSession : NSObject

@property (nonatomic, assign) BOOL shouldAutoHandleServiceErrors;

+ (TPMGServiceSession *)sharedServiceSession;

@end
