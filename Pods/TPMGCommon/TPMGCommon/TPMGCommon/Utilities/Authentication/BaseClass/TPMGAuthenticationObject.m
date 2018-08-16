//
//  TPMGAuthenticationObject.m
//  TPMGCommon
//
//  Created by GK on 6/24/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGAuthenticationObject.h"
#import "TPMGServiceConstants.h"


@implementation TPMGAuthenticationObject


#pragma mark - Error from Status code

- (NSDictionary *)errorResponseForStatusCode:(NSInteger)statusCode {
	NSMutableDictionary *anErrorDictionary = [NSMutableDictionary dictionary];
    [anErrorDictionary setValue:[NSNumber numberWithInteger:statusCode] forKey:kResponseKeyStatusCode];
    
    switch (statusCode) {
        case 5: {
            [anErrorDictionary setValue:kErrorTitleAuthenticationFailed forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageInvalidUser forKey:kResponseKeyStatusMessage];
			
            break;
		}
			
        case 6: {
			[anErrorDictionary setValue:kErrorTitleLockedOut forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageLockedOut forKey:kResponseKeyStatusMessage];
			
            break;
		}
			
        case 7: {
			[anErrorDictionary setValue:kErrorTitleAuthorizationFailed forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageAuthorizationFailed forKey:kResponseKeyStatusMessage];
			
            break;
		}
			
        case 8: {
			[anErrorDictionary setValue:kErrorTitleGeneric forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageNCalUser forKey:kResponseKeyStatusMessage];
			
            break;
		}
            
        case 9: {
            [anErrorDictionary setValue:kErrorTitleMembershipTerminated forKey:kResponseKeyStatusTitle];
            [anErrorDictionary setValue:kErrorMessageMembershipTerminated forKey:kResponseKeyStatusMessage];
            
            break;
        }
            
        case 12: {
            // Title not required for this per US18151
            [anErrorDictionary setValue:@"" forKey:kResponseKeyStatusTitle];
            [anErrorDictionary setValue:kErrorMessagePendingOTP forKey:kResponseKeyStatusMessage];
            
            break;
        }
			
		case 1000: {
			[anErrorDictionary setValue:kErrorTitleGeneric forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageDisabledRegion forKey:kResponseKeyStatusMessage];

			break;
		}
			
        case kErrorCodeGeneric: {
			[anErrorDictionary setValue:kErrorTitleGeneric forKey:kResponseKeyStatusTitle];
			[anErrorDictionary setValue:kErrorMessageGeneric forKey:kResponseKeyStatusMessage];
			
            break;
		}
			
        default:
            break;
    }
	
    return anErrorDictionary;
}


#pragma mark - Decoding

- (NSString *)decodeValueByReplacingPercentEscapes:(NSString *)iEncodedValue {
    NSString *aDecodedValue = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)iEncodedValue, CFSTR("") /* replace all escapes */);
    return aDecodedValue;
}

@end
