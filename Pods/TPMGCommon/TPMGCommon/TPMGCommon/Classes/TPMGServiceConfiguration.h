//
//  TPMGServiceConfiguration.h
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface TPMGServiceConfiguration : NSObject

// Load the configuration from a given property list file name and send it back to the receiver.
+ (NSDictionary *)loadConfigurationFromPropertyListFile:(NSString *)iFileName;

// This returns the configurations from the default file named TPMGConfiguration.plist
// To invoke this method, the implementing application must include TPMGConfiguration.plist.
+ (NSDictionary *)configuration;

@end
