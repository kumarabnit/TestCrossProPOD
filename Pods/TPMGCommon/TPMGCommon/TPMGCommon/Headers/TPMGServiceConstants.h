//
//  TPMGServiceConstants.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

// The timeout for the service requests

#define kServiceRequestTimeOutInSeconds 60

// The HTTP method types.

#define kServiceRequestHTTPMethodPOST	@"POST"
#define kServiceRequestHTTPMethodPUT	@"PUT"
#define kServiceRequestHTTPMethodGET	@"GET"
#define kServiceRequestHTTPMethodDELETE	@"DELETE"

// The alertview cancel button titles.

#define kAlertViewCancelButtonTitleOK		@"Ok"
#define kAlertViewCancelButtonTitleCancel	@"Cancel"
#define kAlertViewCancelButtonTitleClose	@"Close"
#define kAlertViewCancelButtonTitleNO       @"No"
#define kAlertViewCancelButtonTitleActivate       @"Activate"
#define kAlertViewCancelButtonTitleUpdateNow     @"Update Now"



// This is a logging Utility that any application implementing this TPMGCommon module can use.

#ifdef DEBUG
	#define LOG(fmt, ...) NSLog((@"%s %@"), __PRETTY_FUNCTION__, [NSString stringWithFormat:(@fmt), ##__VA_ARGS__])
#else
	#define LOG(fmt, ...)
#endif

/* This is a localization utility that takes the key and the default value.
 * The key corresponds to the key in the Localizable.strings file.
 * The default value corresponds to the value for the key in case the key could not be read or found.
 */
#define TPMGLocalizedStringWithDefaultValue(key, defaultValue) [[NSBundle mainBundle] localizedStringForKey:(key) value:(defaultValue) table:nil]

// The Sign On body parameter keys for Authentication
#define kSignOnUserName		@"username"
#define kSignOnPassword		@"password"
#define kSignOnRegion		@"region"
#define kSignOnAPIKey		@"apiKey"
#define kSignOnAppID		@"appId"
#define kSignOnAppName		@"appName"
#define kSignOnAppVersion	@"appVersion"
#define kSignOnSSOSession	@"ssosession"

// Common request body parameter keys
#define kRequestBodyKeyOS			@"os"
#define kRequestBodyKeyOSVersion	@"osVersion"

// Common request header parameter keys
#define kRequestHeaderKeyUserAgentCategory      @"X-useragentcategory"
#define kRequestHeaderKeyOSVersion              @"X-osversion"
#define kRequestHeaderKeyUserAgentType          @"X-useragenttype"
#define kRequestHeaderAPIKey                    @"X-apiKey"
#define kRequestHeaderKeyAppName                @"X-appName"
#define kRequestHeaderKeyssosession             @"ssosession"
#define kRequestHeaderKeySessionToken           @"SessionToken"
#define kRequestHeaderKeyUserID                 @"X-userId"
#define kRequestHeaderKeyAuthorization          @"Authorization"
#define kRequestHeaderXsessionId                @"X-sessionId"

// Response keys
#define kResponseKey			@"response"
#define kResponseKeyMessage		@"message"
#define kResponseKeyStatusCode	@"statusCode"

// Sign on status code related keys
#define kResponseKeyAccountLocked					@"accountlocked"
#define kResponseKeyAuthenticationFailed			@"authenticationfailed"
#define kResponseKeySystemError						@"systemError"
#define kResponseKeyBussinessError					@"businessError"
#define kResponseKeyInterrupt						@"interruptList"
#define kResponseKeyUser							@"user"
#define kResponseKeyRegion							@"region"
#define kResponseKeyUnableToActivateMychartAccount	@"UNABLE_TO_ACTIVATE_MYCHART_ACCOUNT"
#define kResponseKeyStatusTitle						@"statusTitle"
#define kResponseKeyStatusMessage					@"statusMessage"
#define kResponseKeySSOSession						@"ssosession"
#define kResponseKeyXCorrelationID					@"X-CorrelationID"
#define kResponseKeyCorrelationID					@"corelationId"
#define kResponseKeyEBizAccountRoles				@"ebizAccountRoles"
#define kResponseKeySuccess							@"success"
#define kResponseKeyFailureInfo						@"failureInfo"
#define kResponseKeyUnauthorized					@"unauthorized"
#define kResponseKeyErrorCode						@"errorCode"
#define kActivatinStatusCode                        @"activationStatusCode"

// Sign On keys for MID accounts
#define kMIDREGION @"MID"
#define kMMAPPNAME   @"MyMed"


// Sign on error codes
#define kErrorCodeGeneric        20

// Sign on error messages
#define kErrorTitleAuthenticationFailed		@"Authenication failed"
#define kErrorMessageInvalidUser			@"Invalid User ID/Password. Please try again."
#define kErrorTitleAuthorizationFailed		@"Authorization failed"
#define kErrorMessageAuthorizationFailed	@"Please go to kp.org to activate your account."
#define kErrorTitleLockedOut				@"Locked out"
#define kErrorMessageLockedOut				@"There is a problem with your account. Please go to kp.org for details"
#define kErrorTitleGeneric					@"Error"
#define kErrorMessageNCalUser				@"This app is available only to Kaiser Permanente members in Northern California"
#define kErrorMessageGeneric                @"Your data cannot be retrieved at this time. Please try again later"
#define kErrorMessageDisabledRegion         @"The region user belongs to is disabled."
#define kErrorTitleMembershipTerminated     @"Membership Terminated"
#define kErrorMessageMembershipTerminated   @"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Untitled Document.md</title><style>body {font-family:\"helvetica\";vertical-align: middle;font-size:medium;}</style></head><body id=\"preview\"><p>Our records indicate that you are no longer a Kaiser Permanente member. If you need help at this time, please visit <a href=\"http://kp.org\">kp.org</a> or call Member Services at 800-464-4000.</p></body></html>"
#define kErrorMessagePendingOTP             @"Your one time password activation is pending. Please go to kp.org to activate."


// SSO Interrupt Status Code
#define kInterruptStatusCode 999

// SSO Sign On interrupt response dictionary key
#define kInterruptHeaderResponse        @"cookieResponse"
#define kInterruptBodyResponse          @"signOnResponse"
#define kIsInterruptDictionary          @"isIterruptDictionary"

// SSO Sign On Interrupt Key
#define kSSOIterruptTNCMustAcceptNewVersion         @"TNC MUST ACCEPT NEW VERSION"
#define kSSOIterruptTNCNotAccepted                  @"TNC NOT ACCEPTED"
#define kSSOIterruptTNC365                          @"TNC 365"
#define kSSOIterruptTempPassword                    @"TEMP PWD"
#define kSSOIterruptEmailMismatch                   @"EMAIL MISMATCH"
#define kSSOIterruptSecretQuestions                 @"SECRET QUESTIONS"
#define kSSOIterruptStayInTouch                     @"STAY IN TOUCH"


