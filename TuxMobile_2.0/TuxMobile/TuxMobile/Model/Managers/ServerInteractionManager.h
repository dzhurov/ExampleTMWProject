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
#import "MWAccountManager.h"

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

@property (nonatomic, weak) id <MWAccountManager> accountManager;

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(ServerInteractionManager, sharedManager);

// Account management
- (NSDictionary*)synchronousLogin:(NSDictionary*)login error:(NSError**)error;
- (NSOperation*)userLogin:(NSDictionary*)login responseBlock:(void(^)(NSDictionary *loginResponse, NSError *error))responseBlock;
- (NSOperation*)userLogoutResponseBlock:(void(^)(id _null, NSError *error))responseBlock;

// Orders


//
- (NSURLRequest *)postRequestWithPath:(NSString *)urlString httpBody:(NSData *)data;
- (NSURLRequest *)getRequestWithPath:(NSString *)urlString parameters: (NSDictionary *)parameters;


@end
