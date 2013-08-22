//
//  MWAccountManager.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 08.11.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "MWAccountManager.h"

static const NSTimeInterval kTimeIntervalForAutomaticLogout = (30.f * 60.f); //sec

@class MWUser;

@interface AccountManager : NSObject <MWAccountManager>
{
    NSString *_token;
    NSDate *_expirationDate;
    NSDate *_hibernateDate;
}

@property (nonatomic, readonly) NSDate *expirationDate;
@property (nonatomic, retain) MWUser *user;

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(AccountManager, sharedAccountManager);

- (void) userLogin: (NSString*)login password: (NSString*)password completionBlock: (void (^)(NSError* error))completionBlock;
- (BOOL)reloginSynchronous: (NSError **)error;
- (NSOperation*)userLogoutCompletionBlock: (void (^)(NSError* error))completionBlock;


- (BOOL)isTokenValid;
- (NSString*)token: (NSError **)error;
- (BOOL)userHasBeenLoggedIn;

@end
