//
//  TPMGAuthenticationObject.h
//  TPMGCommon
//
//  Created by GK on 6/24/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface TPMGAuthenticationObject : NSObject

- (NSDictionary *)errorResponseForStatusCode:(NSInteger)statusCode;
- (NSString *)decodeValueByReplacingPercentEscapes:(NSString *)iEncodedValue;

@end
