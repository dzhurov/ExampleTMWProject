//
//  ServerInteractionManager.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 14.09.12.
//  Copyright (c) 2012 The Mens Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "APIConsts.h"

typedef void(^ResponseBlock)(id responseObject, NSError *error);

#define kRequestTimeoutInterval     (NSTimeInterval)(10.f)  //sec


@class AFHTTPClient;
@class Customer;

@interface ServerInteractionManager : NSObject{
#ifdef DEBUG
@public
#endif
    AFHTTPClient *_httpClient;
}

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(ServerInteractionManager, sharedManager);

// Account management

// Orders

//
- (NSURLRequest *)postRequestWithPath:(NSString *)urlString httpBody:(NSData *)data;
- (NSURLRequest *)getRequestWithPath:(NSString *)urlString parameters: (NSDictionary *)parameters;


@end
