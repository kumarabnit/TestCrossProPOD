//
//  TPMGServices.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#ifndef TPMGCommon_TPMGServices_h
#define TPMGCommon_TPMGServices_h
/*
 Only this header needs to be included in the implementing applications .pch file as #include "TPMGServices.h"
 This will ensure all the required files are imported as necessary for the application to use the common module.
 */

#import "TPMGServiceManager.h"
#import "TPMGServiceConfiguration.h"
#import	"TPMGAlertView.h"
#import "TPMGLoadingOverlay.h"
#import "TPMGServiceConstants.h"
#import "TPMGMemberSignOnManager.h"
#import "TPMGMemberSignOffManager.h"
#import "TPMGMemberKeepAliveManager.h"
#import "TPMGCookieManager.h"
#import "TPMGKeychainUtility.h"
#import "TPMGSSOInterruptManager.h"

// Categories
#import "NSData+Additions.h"
#import "NSString+Additions.h"
#import "UIImage+ImageEffects.h"
#import "NSDate+Additions.h"

#endif
