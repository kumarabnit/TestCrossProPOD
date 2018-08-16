//
//  TPMGServiceManager.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceRequest.h"


typedef enum {
	TPMGServiceReqestHTTPMethodPOST,
	TPMGServiceReqestHTTPMethodPUT,
	TPMGServiceReqestHTTPMethodGET,
    TPMGServiceReqestHTTPMethodDELETE
} TPMGServiceReqestHTTPMethod;

typedef enum {
    TPMGSignOnInterruptTNCMustAcceptNewVersion,
    TPMGSignOnInterruptTNCNotAccepted,
    TPMGSignOnInterruptTNC365,
    TPMGSignOnInterruptTempPassword,
    TPMGSignOnInterruptEmailMismatch,
    TPMGSignOnInterruptSecretQuestions,
    TPMGSignOnInterruptStayInTouch
} TPMGSignOnInterrupt;

/* The iSucceeded flag will tell whether the request went through or failed.
 * The iResponseObject can contain an NSDictionary, NSArray or NSError as applicable.
 * The implementing application has to validate the type of the response object on receipt.
 */
typedef void (^TPMGServiceCompletionBlock)(BOOL iSucceeded, id iResponseObject);

/* This block is for the asynchronous request.
 */
typedef void (^TPMGAsyncRequestCompletionBlock)(NSData *iData, NSURLResponse *iResponse, NSError *iError);

/* The iSucceeded flag will tell whether the request went through or failed.
 * The iImage will contain an UIImage object if the image was downloaded succefully else nil.
 * The iImage will be nil if the image download failed.
 */
typedef void (^TPMGImageDownloadCompletionBlock)(BOOL iSucceeded, UIImage *iImage);

/* The iSucceeded flag will tell whether the request went through or failed.
 * The iFileResponseData will contain the NSData of the file to be downloaded if the request is successful else nil.
 * The implementing application has to process the iFileResponseData to their needs.
 */
typedef void (^TPMGFileDownloadCompletionBlock)(BOOL iSucceeded, NSData *iFileResponseData);


@interface TPMGServiceManager : NSObject <TPMGServiceRequestDelegate, NSURLSessionTaskDelegate>

// If the input is set to YES, we should throw the errors from the TPMGCommonModule itself.
// If the input is set to NO, we send back the errors to the application that is making the request.
+ (void)shouldAutoHandleServiceErrors:(BOOL)iShouldAutoHandle;

/* This method can be invoked to fire a request to get the required data.
 * This method will return the NSDictionary or NSArray objects if the request is successful.
 * This method will return the NSError object or an Error dictionary if the request fails.
 */

+ (instancetype)sendRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock;

+ (TPMGServiceManager *)sendBackgroundAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock;

// Asynchronous request
+ (instancetype)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock;

// Method that takes the body as a JSON string
+ (instancetype)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock;

// This method can be invoked to download an image from a given URL.

+ (instancetype)downloadImageFromURL:(NSURL *)iImageURL completionBlock:(TPMGImageDownloadCompletionBlock)iCompletionBlock;

// This method can be invoked to download a file from a given URL.

+ (instancetype)downloadFileFromURL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGFileDownloadCompletionBlock)iCompletionBlock;

+ (instancetype)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod DATAbody:(NSMutableData*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock;

+ (instancetype)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod immutableDataBody:(NSData*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock;

// Used to resend a log file that failed
- (void)sendAFile:(NSURL *)iRequstURL boundary:(NSString *)boundary filePath:(NSString *)filePath iSession:(NSURLSession *)iSession;

// Used for posting the vidyo log file to the server.
+ (instancetype)uploadFileToURL:(NSURL*)iRequestURL NSURLSessionConfigOrNil:(NSURLSessionConfiguration*)iSessionConfig headers:(NSDictionary*)iHeaders parameters:(NSDictionary *)iParameters filePath:(NSString*)iFilePath completionBlock:(TPMGFileDownloadCompletionBlock)iCompletionBlock;

// UniqueString (UUID without the "-" so can be used in file names
+ (NSString*) getUniqueString;

// list all files in the directory, 
+ (NSMutableArray*) getFilePathsInDir:(NSString*)dirPath withNamePrefix:(NSString*)namePrefix withSuffix:(NSString*)typeSuffix;

+ (NSString*) getHWString;
@end
