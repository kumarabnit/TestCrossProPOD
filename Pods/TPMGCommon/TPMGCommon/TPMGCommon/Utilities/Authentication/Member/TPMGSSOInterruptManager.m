//
//  TPMGSignOnInterruptManager.m
//  JVFloatLabeledTextField
//
//  Created by Amardeep Kaur on 18/06/18.
//

#import "TPMGSSOInterruptManager.h"

@implementation TPMGSSOInterruptManager

#pragma mark - Token API to get client cookie

+ (void)tokenAPIToFetchClientCookieHeader:(NSDictionary *)iHeaderDictionary URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    [TPMGServiceManager sendAsynchronousRequestWithURL:iURL method:iHTTPMethod body:nil header:iHeaderDictionary completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        if (iError) {
            iCompletionBlock(NO, iResponse);
        } else {
            iCompletionBlock(YES, iResponse);
        }
    }];
}

#pragma mark - Portal API to get LtpaToken2

+ (void)portalApiWithHeaderParameter:(NSDictionary *)iHeaderDictionary URL:(NSURL *)iURL method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSDictionary *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    [TPMGServiceManager sendAsynchronousRequestWithURL:iURL method:iHTTPMethod body:nil header:iHeaderDictionary completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        iCompletionBlock(YES, iResponse);
    }];
}

#pragma mark - Interrupt API GET and PUT.

+(void) signOnInterruptURLWith:(NSURL *)iURL header:(NSDictionary *)iHeaderDictionary method:(TPMGServiceReqestHTTPMethod)iHTTPMethod parameters:(NSData *)iParameters completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    TPMGSSOInterruptManager *aSignOnInterruptManager = [[TPMGSSOInterruptManager alloc] init];
    
    [TPMGServiceManager sendAsynchronousRequestWithURL:iURL method:iHTTPMethod immutableDataBody:iParameters header:iHeaderDictionary completionBlock:^(NSData *iData, NSURLResponse *iResponse, NSError *iError) {
        if (iError) {
            [aSignOnInterruptManager signOnInterruptDidFail:iError response:iResponse data:iData completionBlock:iCompletionBlock];
        } else {
            [aSignOnInterruptManager signOnInterruptDidSucceedWithData:iData reponse:iResponse completionBlock:iCompletionBlock];
        }
    }];
}

#pragma mark - Private methods

-(void) signOnInterruptDidSucceedWithData:(NSData *)iData reponse:(NSURLResponse *)iResponse completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    LOG("Interrupt Response Data :\n%@", [[NSString alloc] initWithBytes:[iData bytes] length:[iData length] encoding:NSUTF8StringEncoding]);
    
    NSError *iError = nil;
    NSDictionary *aResponseDictionary = [NSJSONSerialization JSONObjectWithData:iData options:NSJSONReadingMutableContainers error:&iError];
    
    if (!iError && [aResponseDictionary isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *interruptResponseDictionary = [NSMutableDictionary dictionary];
        
        NSHTTPURLResponse *aHTTPResponse = (NSHTTPURLResponse *)iResponse;
        NSDictionary *theHeaderFields = [[NSDictionary alloc]init];
        if([aHTTPResponse respondsToSelector:@selector(allHeaderFields)]) {
            theHeaderFields = [aHTTPResponse allHeaderFields];
        }
        [interruptResponseDictionary setObject:theHeaderFields forKey:kInterruptHeaderResponse];
        [interruptResponseDictionary setObject:aResponseDictionary forKey:kInterruptBodyResponse];
        [interruptResponseDictionary setObject:@"true" forKey:kIsInterruptDictionary];
        iCompletionBlock(YES, interruptResponseDictionary);
    } else {
        NSMutableDictionary *errorDictionary = [[NSMutableDictionary alloc] init];
        [errorDictionary setObject:kErrorTitleGeneric forKey:kResponseKeyStatusTitle];
        [errorDictionary setObject:kErrorMessageGeneric forKey:kResponseKeyStatusMessage];
        [errorDictionary setValue:[NSNumber numberWithInteger:20] forKey:kResponseKeyStatusCode];
        iCompletionBlock(NO, errorDictionary);
    }
}

-(void) signOnInterruptDidFail:(NSError *)iError response:(NSURLResponse *)iResponse data:(NSData *)data completionBlock:(TPMGServiceCompletionBlock)iCompletionBlock {
    /*NSMutableDictionary *errorDictionary = [[NSMutableDictionary alloc] init];
     [errorDictionary setObject:kErrorTitleGeneric forKey:kResponseKeyStatusTitle];
     [errorDictionary setObject:kErrorMessageGeneric forKey:kResponseKeyStatusMessage];
     [errorDictionary setValue:[NSNumber numberWithInteger:20] forKey:kResponseKeyStatusCode];*/
    id aParsedResponseObject = nil;
    NSError *anError = nil;
    
    NSString *aJsonString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    
    aParsedResponseObject = [NSJSONSerialization JSONObjectWithData:[aJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&anError];
    
    if (anError != nil) {
        LOG("Parsing the response failed : Error : %@", [anError localizedDescription]);
        LOG("----- responseString = %@", aJsonString);
    }
    NSMutableDictionary * responseData = [NSMutableDictionary new];
    if (aParsedResponseObject != nil) {
        [responseData setObject:aParsedResponseObject forKey:@"data"];
    }
    if (iResponse != nil) {
        [responseData setObject:iResponse forKey:@"httpResponse"];
    }
    iCompletionBlock(NO, responseData);
}


@end
