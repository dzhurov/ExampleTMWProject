//
//  Utilities.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 31.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isValidEmail(NSString *candidate);
BOOL isValidGroup(NSString *candidate);
BOOL isValidPhoeNumber(NSString *candidate);
BOOL isValidName(NSString *candidate);
BOOL isValidUserName(NSString *candidate);
BOOL isValidPassword(NSString *candidate);
CGFloat heightOfTextLabel(NSString* text, CGFloat width, UIFont* font);
NSString * NSStringBase64FromData(NSData* data);


@interface Utilities : NSObject

+ (NSString*)NSStringBase64FromData: (NSData *)data;

@end
