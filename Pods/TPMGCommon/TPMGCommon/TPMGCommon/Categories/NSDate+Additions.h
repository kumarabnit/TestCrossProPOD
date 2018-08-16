//
//  NSDate+Additions.h
//  PreventiveCare
//
//  Created by Abhinav Sehgal.
//  Copyright (c) 2014 Kaiser Permanente. All rights reserved.
//

@interface NSDate (Additions)

// Returns a date string for the input date and input date format.
+ (NSString *)stringFromDate:(NSDate *)iDate format:(NSString *)iDateFormatString;

// Returns a date object from the given string. The string expected is a stringValue of NSTimeInterval.
+ (NSDate *)dateFromString:(NSString *)iDateString;

@end
