//
//  NSDictionary+NullValue.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 30.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "NSDictionary+NullValue.h"

@implementation  NSDictionary (NullValue)

- (id) objectForKeyOrNilIfNotExists:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isKindOfClass:[NSNull class]]){
        return nil;
    }
    return object;
}

@end
