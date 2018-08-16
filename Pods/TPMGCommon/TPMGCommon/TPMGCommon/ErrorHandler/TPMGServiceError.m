//
//  TPMGServiceError.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceError.h"
#import "TPMGAlertView.h"
#import "TPMGServiceSession.h"


@implementation TPMGServiceError


#pragma mark - Response validation

+ (BOOL)isResponseValid:(NSURLResponse *)iResponse {
	BOOL isResponseValid = YES;
	
	NSHTTPURLResponse *aHTTPURLResponse = (NSHTTPURLResponse *)iResponse;
	NSInteger aStatusCode = [aHTTPURLResponse statusCode];
	
	isResponseValid = [TPMGServiceError isStatusCodeValid:aStatusCode];
	
	return isResponseValid;
}


+ (BOOL)isStatusCodeValid:(NSInteger)iStatusCode {
	BOOL isStatusCodeValid = YES;
	
	switch (iStatusCode) {
		case 400 : {
			isStatusCodeValid = NO;
 
			break;
		}
			
		case 403 : {
			isStatusCodeValid = NO;

			break;
		}
			
		case 404 : {
			isStatusCodeValid = NO;

			break;
		}
			
		case 500 : {
			isStatusCodeValid = NO;

			break;
		}
			
		case 503 : {
			isStatusCodeValid = NO;

			break;
		}
			
		default: {
			break;
		}
	}
	
	[TPMGServiceError displayErrorForStatusCode:iStatusCode];
	
	return isStatusCodeValid;
}


+ (void)displayErrorForStatusCode:(NSInteger)iStatusCode {
	if ([TPMGServiceSession sharedServiceSession].shouldAutoHandleServiceErrors) {
		switch (iStatusCode) {
			case 400 : {
				[TPMGAlertView showAlertWithMessage:@"" title:@"Error" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
				break;
			}
				
			case 403 : {
				[TPMGAlertView showAlertWithMessage:@"" title:@"Error" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
				break;
			}
				
			case 404 : {
				[TPMGAlertView showAlertWithMessage:@"" title:@"Error" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
				break;
			}
				
			case 500 : {
				[TPMGAlertView showAlertWithMessage:@"" title:@"Error" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
				break;
			}
				
			case 503 : {
				[TPMGAlertView showAlertWithMessage:@"" title:@"Error" cancelButtonTitle:TPMGAlertViewCancelButtonTitleOK];
				break;
			}
				
			default: {
				break;
			}
		}
	}
}


@end
