#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSData+Additions.h"
#import "NSDate+Additions.h"
#import "NSString+Additions.h"
#import "UIImage+ImageEffects.h"
#import "TPMGServiceConfiguration.h"
#import "TPMGServiceSession.h"
#import "TPMGServiceError.h"
#import "TPMGServiceConstants.h"
#import "TPMGServices.h"
#import "TPMGServiceManager.h"
#import "TPMGReachability.h"
#import "TPMGServiceReachability.h"
#import "TPMGBaseServiceRequest.h"
#import "TPMGFileDownloadRequest.h"
#import "TPMGImageDownloadRequest.h"
#import "TPMGServiceRequest.h"
#import "TPMGAuthenticationChallengeHandler.h"
#import "TPMGKeychainUtility.h"
#import "TPMGAlertView.h"
#import "TPMGAuthenticationObject.h"
#import "TPMGMemberKeepAliveManager.h"
#import "TPMGMemberSignOffManager.h"
#import "TPMGMemberSignOnManager.h"
#import "TPMGSSOInterruptManager.h"
#import "TPMGCookieManager.h"
#import "TPMGLoadingOverlay.h"

FOUNDATION_EXPORT double TPMGCommonVersionNumber;
FOUNDATION_EXPORT const unsigned char TPMGCommonVersionString[];

