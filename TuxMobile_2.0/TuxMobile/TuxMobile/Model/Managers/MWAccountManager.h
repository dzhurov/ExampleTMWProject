//
//  MWAccountManager.h
//  TuxMobile
//
//  Created by DZhurov on 8/22/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWAccountManager <NSObject>

- (BOOL)reloginSynchronous:(NSError**)error;
- (NSString*)token:(NSError**)error;

@end
