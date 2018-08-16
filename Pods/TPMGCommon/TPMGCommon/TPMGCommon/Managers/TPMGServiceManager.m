//
//  TPMGServiceManager.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceManager.h"
#import "TPMGFileDownloadRequest.h"
#import "TPMGImageDownloadRequest.h"
#import "TPMGServiceConstants.h"
#import "TPMGServiceSession.h"
@import MobileCoreServices;
#include <sys/types.h>
#include <sys/sysctl.h>

@interface TPMGServiceManager ()

@property (nonatomic, strong) void(^requestCompletionBlock)(BOOL iSucceeded, id iResponseObject);
@property (nonatomic, strong) NSMutableDictionary* responseDataDict;
@property (nonatomic, strong) NSString* urlSessionID;
@end


@implementation TPMGServiceManager


#pragma mark - Service Request

+ (TPMGServiceManager *)sendRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
	TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
	aServiceManager.requestCompletionBlock = iCompletionBlock;
	[aServiceManager sendRequestWithURL:iRequestURL method:iHTTPMethod body:iBodyParameters header:iHeaderParameters];
	
	return aServiceManager;
}


+ (TPMGServiceManager *)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
	TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
	[aServiceManager sendAsynchronousRequestWithURL:iRequestURL method:iHTTPMethod body:iBodyParameters header:iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock];

	return aServiceManager;
}

+ (TPMGServiceManager *)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock
{
    TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
    [aServiceManager sendAsynchronousRequestWithURL:iRequestURL method:iHTTPMethod JSONbody:body header:iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock];
    
    return aServiceManager;
}

+ (TPMGServiceManager *)sendBackgroundAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock
{
    TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
    [aServiceManager sendBackgroundAsynchronousRequestWithURL:iRequestURL method:iHTTPMethod JSONbody:body header:iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock];
    
    return aServiceManager;
}

+ (TPMGServiceManager *)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod DATAbody:(NSMutableData*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock
{
    TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
    [aServiceManager sendAsynchronousRequestWithURL:iRequestURL method:iHTTPMethod DATAbody:body header:iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock];
    
    return aServiceManager;
}

+ (TPMGServiceManager *)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod immutableDataBody:(NSData*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock
{
    TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
    [aServiceManager sendAsynchronousRequestWithURL:iRequestURL method:iHTTPMethod immutableDataBody:body header:iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock];
    
    return aServiceManager;
}

#pragma mark - Image Download Request

+ (TPMGServiceManager *)downloadImageFromURL:(NSURL *)iImageURL completionBlock:(TPMGImageDownloadCompletionBlock)iCompletionBlock {
	TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
	[aServiceManager downloadImageFromURL:iImageURL completionBlock:iCompletionBlock];
	return aServiceManager;
}


#pragma mark - File Download Request

+ (TPMGServiceManager *)downloadFileFromURL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGFileDownloadCompletionBlock)iCompletionBlock {
	TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
	[aServiceManager downloadFileFromURL:iURL method:iHTTPMethod body:iBodyParameters header:iHeaderParameters completionBlock:iCompletionBlock];
	return aServiceManager;
}

#pragma mark - housekeeping
- (instancetype) init {
    if (self = [super init]) {
        self.responseDataDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    self.responseDataDict = nil;
}

#pragma mark - TPMGServiceRequest delegates

- (void)requestDidSucceedWithResponse:(id)iResponse {
	if (self.requestCompletionBlock) {
		self.requestCompletionBlock(YES, iResponse);
	}
}


- (void)requestDidFailWithResponse:(id)iResponse {
	if (self.requestCompletionBlock) {
		self.requestCompletionBlock(NO, iResponse);
	}
}


#pragma mark - Private Methods.

- (NSString *)requestHTTPMethodStringWithType:(TPMGServiceReqestHTTPMethod)iHTTPMethod {
	NSString *aRequestHTTPMethodString = nil;
	
	switch (iHTTPMethod) {
		case TPMGServiceReqestHTTPMethodPOST: {
			aRequestHTTPMethodString = kServiceRequestHTTPMethodPOST;
			break;
		}
			
		case TPMGServiceReqestHTTPMethodGET: {
			aRequestHTTPMethodString = kServiceRequestHTTPMethodGET;
			break;
		}
			
		case TPMGServiceReqestHTTPMethodPUT: {
			aRequestHTTPMethodString = kServiceRequestHTTPMethodPUT;
			break;
		}
            
        case TPMGServiceReqestHTTPMethodDELETE: {
            aRequestHTTPMethodString = kServiceRequestHTTPMethodDELETE;
            break;
        }
			
		default:
			break;
	}
	
	return aRequestHTTPMethodString;
}


+ (void)shouldAutoHandleServiceErrors:(BOOL)iShouldAutoHandle {
	[TPMGServiceSession sharedServiceSession].shouldAutoHandleServiceErrors = iShouldAutoHandle;
}


- (void)sendRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters {
	TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
	aServiceRequest.requestBody = iBodyParameters;
	aServiceRequest.requestHeaders = iHeaderParameters;
	aServiceRequest.delegate = self;
	aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
	
	[aServiceRequest fireRequestWithURL:iRequestURL];
}


- (void)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
	TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
	aServiceRequest.requestBody = iBodyParameters;
	aServiceRequest.requestHeaders = iHeaderParameters;
	aServiceRequest.delegate = self;
	aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
	
	[aServiceRequest fireAsynchorousRequestWithURL:iRequestURL completionBlock:iCompletionBlock];
}

- (void)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
    TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
    aServiceRequest.JSONBody = body;
    aServiceRequest.requestHeaders = iHeaderParameters;
    aServiceRequest.delegate = self;
    aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
    
    [aServiceRequest fireAsynchorousRequestWithURL:iRequestURL completionBlock:iCompletionBlock];
}

- (void)sendBackgroundAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod JSONbody:(NSString*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
    TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
    aServiceRequest.JSONBody = body;
    aServiceRequest.requestHeaders = iHeaderParameters;
    aServiceRequest.delegate = self;
    aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
    
    [aServiceRequest fireBackgroundAsynchorousRequestWithURL:iRequestURL completionBlock:iCompletionBlock];
}

- (void)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod DATAbody:(NSMutableData*)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
    TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
    aServiceRequest.dataBody = body;
    aServiceRequest.requestHeaders = iHeaderParameters;
    aServiceRequest.delegate = self;
    aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
    
    [aServiceRequest fireAsynchorousRequestWithURL:iRequestURL completionBlock:iCompletionBlock];
}

- (void)sendAsynchronousRequestWithURL:(NSURL *)iRequestURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod immutableDataBody:(NSData *)body header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGAsyncRequestCompletionBlock)iCompletionBlock {
    TPMGServiceRequest *aServiceRequest = [[TPMGServiceRequest alloc] init];
    aServiceRequest.immutableDataBody = body;
    aServiceRequest.requestHeaders = iHeaderParameters;
    aServiceRequest.delegate = self;
    aServiceRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
    
    [aServiceRequest fireAsynchorousRequestWithURLForPUT:iRequestURL completionBlock:iCompletionBlock];
}

- (void)downloadImageFromURL:(NSURL *)iImageURL completionBlock:(TPMGImageDownloadCompletionBlock)iCompletionBlock {
	TPMGImageDownloadRequest *anImageDownLoadRequest = [[TPMGImageDownloadRequest alloc] init];
	[anImageDownLoadRequest downloadImageFromURL:iImageURL completionBlock:iCompletionBlock];
}


- (void)downloadFileFromURL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod body:(NSDictionary *)iBodyParameters header:(NSDictionary *)iHeaderParameters completionBlock:(TPMGFileDownloadCompletionBlock)iCompletionBlock {
	TPMGFileDownloadRequest *aFileDownloadRequest = [[TPMGFileDownloadRequest alloc] init];
	aFileDownloadRequest.requestHTTPMethod = [self requestHTTPMethodStringWithType:iHTTPMethod];
	aFileDownloadRequest.requestHeaders = iHeaderParameters;
	aFileDownloadRequest.requestBody = iBodyParameters;
	[aFileDownloadRequest downloadFileFromURL:iURL completionBlock:iCompletionBlock];
}

- (void)sendAFile:(NSURL *)iRequstURL boundary:(NSString *)boundary filePath:(NSString *)filePath iSession:(NSURLSession *)iSession {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:iRequstURL];
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSURLSessionUploadTask* uploadFileTask = [iSession uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath]];
    [uploadFileTask resume];
}

+ (instancetype)uploadFileToURL:(NSURL*)iRequestURL NSURLSessionConfigOrNil:(NSURLSessionConfiguration*)iSessionConfig headers:(NSDictionary*)iHeaders parameters:(NSDictionary *)iParameters filePath:(NSString*)iFilePath completionBlock:(TPMGFileDownloadCompletionBlock)iCompletionBlock {
    TPMGServiceManager *aServiceManager = [[[self class] alloc] init];
    aServiceManager.requestCompletionBlock = iCompletionBlock;
    aServiceManager.urlSessionID = [TPMGServiceManager getUniqueString];
    
    NSURLSessionConfiguration* tempConfig = iSessionConfig;
    if (tempConfig == nil) {
        //tempConfig = [NSURLSessionConfiguration  backgroundSessionConfigurationWithIdentifier:[TPMGServiceManager getUniqueString]];
        tempConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    [tempConfig setHTTPAdditionalHeaders:iHeaders];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:tempConfig delegate:aServiceManager delegateQueue:[NSOperationQueue mainQueue]];
    [session setSessionDescription:aServiceManager.urlSessionID];
    
    [aServiceManager uploadFileToURL:iRequestURL withSession:(NSURLSession*)session filePath:iFilePath parameters:iParameters];
    
    return aServiceManager;

}

-(void)uploadFileToURL:(NSURL*)iRequstURL withSession:(NSURLSession*)iSession filePath:(NSString*)iFilePath parameters:(NSDictionary*)iParameters {

    NSURL* fileDataURL = [NSURL fileURLWithPath:iFilePath isDirectory:NO];
    if (fileDataURL != nil) {
        NSString* boundary = [NSString stringWithFormat:@"Boundary-%@", iSession.sessionDescription];
        
        NSMutableData* httpBody = [NSMutableData data];

        // TODO: Copy the log file to a private data store.
        NSData   *data      = [NSData dataWithContentsOfFile:iFilePath];
        NSString *mimetype  = [self mimeTypeForPath:@"txt"];
        NSString* uniqueNameToPost = [NSString stringWithFormat:@"%@.log", iSession.sessionDescription];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vidyoLog\"; filename=\"%@\"\r\n", uniqueNameToPost] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Posting multipart form data
        [iParameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", parameterKey, parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fileNameFormat;
        NSString* guestKey = [iParameters objectForKey:@"memberName"];
        if (guestKey != nil) {
            // It's a guest posting, so name it that way.
            fileNameFormat = @"guest%@.data";
        } else {
            fileNameFormat = @"normal%@.data";
        }
        NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:fileNameFormat, iSession.sessionDescription]];
        NSError* dataError;
        BOOL successfulWrite = [httpBody writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&dataError];

        if (successfulWrite == YES) {
            [self sendAFile:iRequstURL boundary:boundary filePath:filePath iSession:iSession];
        }
    }
}

#pragma mark - urlsession delegates

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSMutableData *responseData = self.responseDataDict[@(dataTask.taskIdentifier)];
    if (!responseData) {
        responseData = [NSMutableData dataWithData:data];
        [self.responseDataDict setObject:responseData forKey:@(dataTask.taskIdentifier)];
    } else {
        [responseData appendData:data];
    }
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    BOOL shouldDelete = NO;
    if (error == nil) {
        // upload successful, delete the log file.
        NSMutableData *responseData = [self.responseDataDict objectForKey:@(task.taskIdentifier)];
        if (responseData != nil) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if (response) {
                NSDictionary* topDict = [response objectForKey:@"response"];
                if (topDict != nil) {
                    NSNumber* statusCode = [topDict objectForKey:@"statusCode"];
                    if ([statusCode integerValue] == 0) {
                        shouldDelete = YES;
                    } else {
                        LOG("response = %@", response);
                    }
                } else {
                    LOG("response = %@", response);
                }
            } else {
                LOG("responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            }
        }
        [self.responseDataDict removeObjectForKey:@(task.taskIdentifier)];
    }
    
    if (shouldDelete == YES) {
        // TODO - Remove the stuff so it won't get sent again:
        // remove the file session.sessionDescription.data in the documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"normal%@.data", session.sessionDescription]];
        BOOL didDelete = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (didDelete == NO) {
            filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"guest%@.data", session.sessionDescription]];
            didDelete = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            if (didDelete == NO) {
                LOG("File %@ was not deleted.", filePath);
            }
        }
    }
}

#pragma mark - Some utitlities
+ (NSString*) getUniqueString {
    NSString *retString = [[NSUUID UUID] UUIDString];
    retString = [retString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return retString;
}

+ (NSString*) getHWString {
    static dispatch_once_t singleton_queue;
    static NSString* hardwareString = nil;
    
    dispatch_once(&singleton_queue, ^{
        size_t size = 100;
        char *hw_machine = malloc(size);
        int name[] = {CTL_HW,HW_MACHINE};
        sysctl(name, 2, hw_machine, &size, NULL, 0);
        hardwareString = [NSString stringWithUTF8String:hw_machine];
        free(hw_machine);
    });
    
    return hardwareString;
}

+ (NSMutableArray*) getFilePathsInDir:(NSString*)dirPath withNamePrefix:(NSString*)namePrefix withSuffix:(NSString*)typeSuffix {
    NSMutableArray* retArray = [[NSMutableArray alloc] init];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL];
    for (NSString* filePath in directoryContent) {
        if (namePrefix != nil) {
            if ([[filePath lastPathComponent] hasPrefix:namePrefix] == NO) {
                continue;
            }
        }
        if (typeSuffix != nil) {
            if ([[filePath pathExtension] compare:typeSuffix] != NSOrderedSame) {
                continue;
            }
        }
        [retArray addObject:[dirPath stringByAppendingPathComponent:filePath]];
    }

    return retArray;
}

- (NSString *)mimeTypeForPath:(NSString *)iExtenstion
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)iExtenstion;
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    
    CFRelease(UTI);
    
    return mimetype;
}



@end
