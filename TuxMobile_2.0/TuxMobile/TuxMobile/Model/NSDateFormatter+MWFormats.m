//
//  NSDateFormatter+MWGMT.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 17.05.13.
//  Copyright (c) 2013 Dmitry Zhurov. All rights reserved.
//

#import "NSDateFormatter+MWFormats.h"

@implementation NSDateFormatter (MWFormats)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (NSDateFormatter *)yearMonthDayDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if ( !dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kYearMonthDayDateFormat;
    }
    return dateFormatter;
}

+ (NSDateFormatter *)yearMonthDayAndTimeDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if ( !dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = kYearMonthDayAndTimeDateFormat;
    }
    return dateFormatter;
}

@end
