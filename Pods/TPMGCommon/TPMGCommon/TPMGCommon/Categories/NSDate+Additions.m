//
//  NSDate+Additions.m
//  PreventiveCare
//
//  Created by Abhinav Sehgal.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

#import "NSDate+Additions.h"


@implementation NSDate (Additions)


+ (NSString *)stringFromDate:(NSDate *)iDate format:(NSString *)iDateFormatString {
	NSString *aDateString = @"";

	if ([iDate isKindOfClass:[NSDate class]]) {
		NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
		[aDateFormatter setDateFormat:iDateFormatString];
		aDateString = [aDateFormatter stringFromDate:iDate];
	}

	return aDateString;
}


+ (NSDate *)dateFromString:(NSString *)iDateString {
	NSDate *aReturnDate = [NSDate dateWithTimeIntervalSince1970:0];

	if ([iDateString isKindOfClass:[NSString class]]) {
		signed long long aLongDate = [iDateString longLongValue];
		NSTimeInterval aTimeInterval = aLongDate / 1000;
		aReturnDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
	}

	return aReturnDate;
}

@end