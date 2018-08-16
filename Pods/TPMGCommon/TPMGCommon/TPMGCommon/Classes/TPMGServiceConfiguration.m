//
//  TPMGServiceConfiguration.m
//  TPMGCommon
//
//  Created by GK on 5/19/14.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "TPMGServiceConfiguration.h"


@interface TPMGServiceConfiguration ()

+ (NSDictionary *)fetchConfigurationFromPropertyListFile:(NSString *)iFileName;

@end

@implementation TPMGServiceConfiguration


+ (NSDictionary *)loadConfigurationFromPropertyListFile:(NSString *)iFileName {
	NSDictionary *aConfigurationDictionary = [self fetchConfigurationFromPropertyListFile:iFileName];
	
	return aConfigurationDictionary;
}


+ (NSDictionary *)configuration {
	NSDictionary *aConfigurationDictionary = [self fetchConfigurationFromPropertyListFile:@"TPMGConfiguration"];

	return aConfigurationDictionary;
}


+ (NSDictionary *)fetchConfigurationFromPropertyListFile:(NSString *)iFileName {
	NSDictionary *aConfigurationDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:iFileName ofType:@"plist"]];
	
	return aConfigurationDictionary;
}


@end
