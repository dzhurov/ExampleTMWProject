//
//  NSDictionary+NullValue.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 30.10.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullValue)

- (id) objectForKeyOrNilIfNotExists:(id)aKey;

@end
