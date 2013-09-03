//
//  NSDateFormatter+MWGMT.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 17.05.13.
//  Copyright (c) 2013 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kYearMonthDayDateFormat = @"yyyy-MM-dd";
static NSString *const kYearMonthDayAndTimeDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

@interface NSDateFormatter (MWFormats)

+ (NSDateFormatter *)yearMonthDayDateFormatter;
+ (NSDateFormatter *)yearMonthDayAndTimeDateFormatter;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString*)dateFormat;
@end
