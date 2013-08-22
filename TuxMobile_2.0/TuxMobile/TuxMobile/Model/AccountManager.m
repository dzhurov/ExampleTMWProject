//
//  MWAccountManager.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 08.11.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "AccountManager.h"
#import "ServerInteractionManager.h"
#import "MWStoreManager.h"
#import "Notifications.h"

#define kLoginKey           @"loginKey"
#define kPasswordKey        @"passwordKey"
#define kTokenKey           @"tokenKey"
#define kExpirationDateKey  @"expirationDateKey"

#define kEncodedUserKey     @"EncodedUserKey"
#define kHibernateDateKey   @"kHibernateDateKey"

@interface AccountManager ()

@property (nonatomic, readonly) NSString *token;

@end


@implementation AccountManager

@dynamic token;
@synthesize expirationDate = _expirationDate;

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(AccountManager, sharedAccountManager);


- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *user = [defaults objectForKey:kEncodedUserKey];
        self.user = (MWUser *)[NSKeyedUnarchiver unarchiveObjectWithData: user];
        _token = [[[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey] retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)userLogin:(NSString *)login password:(NSString *)password completionBlock:(void (^)(NSError *))completionBlock
{
    LoginEntity *loginEntity = [LoginEntity loginEntityWithLogin:login password:password];
    [[ServerInteractionManager sharedManager] userLogin:loginEntity responseBlock:^(NSDictionary *loginResponse, NSError *error) {
        if (error){
            completionBlock(error);
            return;
        }
        else{
            [_token release];
            _token = [[loginResponse objectForKey:@"token"] retain];
            [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kTokenKey];
            NSString *expDateString = [loginResponse objectForKey:@"expirationDate"] ;
            [_expirationDate release];
            _expirationDate = [[[NSDateFormatter yearMonthDayAndTimeDateFormatter] dateFromString:expDateString] retain];
            [[NSUserDefaults standardUserDefaults] setObject:_expirationDate forKey:kExpirationDateKey];
            MWUser *user = [[MWUser alloc] initWithJSONDictionary:[loginResponse objectForKey:@"user"]];
            self.user = user;
            NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:kEncodedUserKey];
            [user release];
            
            [[NSUserDefaults standardUserDefaults] setObject:login forKey:kLoginKey];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordKey];
            
            NSDictionary *storeInfo = [[loginResponse objectForKeyOrNilIfNotExists: @"user"] objectForKeyOrNilIfNotExists:@"store"];
            [[MWStoreManager sharedStoreManager] userDidLoginStoreInfo:storeInfo];
            
            completionBlock(nil);
        }
    }];
}

- (BOOL)reloginSynchronous:(NSError **)error
{
    if ([self userHasBeenLoggedIn]){
        NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
        LoginEntity *loginEntity = [LoginEntity loginEntityWithLogin:login password:password];
        NSDictionary *loginResponseDict = [[ServerInteractionManager sharedManager] synchronousLogin:loginEntity error:error];
        if (*error){
            return NO;
        }
        else{
            NSString *token = [loginResponseDict objectForKey:@"token"];
            if (token.length){
                [_token release];
                _token = [token retain];
                [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kTokenKey];
                NSString *expdateString = [loginResponseDict objectForKey:@"expirationDate"];
                [_expirationDate release];
                _expirationDate = [[[NSDateFormatter yearMonthDayAndTimeDateFormatter] dateFromString:expdateString] retain];
                [[NSUserDefaults standardUserDefaults] setObject:_expirationDate forKey:kExpirationDateKey];
                NSDictionary *storeInfo = [[loginResponseDict objectForKeyOrNilIfNotExists: @"user"] objectForKeyOrNilIfNotExists:@"store"];
                
                MWUser *user = [[MWUser alloc] initWithJSONDictionary:[loginResponseDict objectForKey:@"user"]];
                self.user = user;
                NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:kEncodedUserKey];
                [user release];
                
                [[MWStoreManager sharedStoreManager] userDidLoginStoreInfo:storeInfo];
                *error = nil;
                return YES;
            }
            else{
                DDLogError(@"NO TOKEN! responseDictionary:\n%@", loginResponseDict);
                NSDictionary *eDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Token is invalid. Please try re-login.",  NSLocalizedDescriptionKey, nil];
                *error = [NSError errorWithDomain:@"ServerInteractionManager" code:0 userInfo:eDict];
                return NO;
            }
        }
    }
    DDLogError(@"NO TOKEN!");
    NSDictionary *eDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Token is invalid. Please try re-login.",  NSLocalizedDescriptionKey, nil];
    if (error)
        *error = [NSError errorWithDomain:@"ServerInteractionManager" code:0 userInfo:eDict];
    
    return NO;
}

- (NSOperation*)userLogoutCompletionBlock:(void (^)(NSError *))completionBlock
{
    return [[ServerInteractionManager sharedManager] userLogoutResponseBlock:^(id _null, NSError *error) {
        if (!error){
            [_token release], _token = nil;
            [_expirationDate release], _expirationDate = nil;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:kLoginKey];
            [userDefaults removeObjectForKey:kPasswordKey];
            [userDefaults removeObjectForKey:kTokenKey];
            [userDefaults removeObjectForKey:kExpirationDateKey];
            [userDefaults removeObjectForKey:kEncodedUserKey];
        }
        if (completionBlock){
            completionBlock(error);
        }
    }];
}

- (BOOL)userHasBeenLoggedIn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasLoginAndPassword = [userDefaults objectForKey:kLoginKey] && [userDefaults objectForKey:kPasswordKey];
    return hasLoginAndPassword;
}

- (NSString *)token
{
    if (!_token){
        _token = [[[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey] retain];;
    }
    return _token;
}

- (NSDate *)expirationDate
{
    if (!_expirationDate){
        _expirationDate = [[[NSUserDefaults standardUserDefaults] objectForKey:kExpirationDateKey] retain];
    }
    return _expirationDate;
}

- (BOOL)isTokenValid
{
    if ([[self.expirationDate dateByAddingTimeInterval: 5] compare:[NSDate date]] == NSOrderedDescending) // 5 is max time needed for request
        return YES;
    return NO;
}

- (NSString *)token:(NSError **)error
{
    if (self.token && self.isTokenValid){
        if (error != NULL) {
            *error = nil;
        }
        return _token;
    }
    else if ([self userHasBeenLoggedIn]){
        if ([self reloginSynchronous:error]){
            return self.token;
        }
        else{
            return nil;
        }
    }
    else{
        if (error != NULL) {
            *error = nil;
        }
        return nil;
    }
    
}

- (NSOperation *)createAccountForUser:(MWUser *)user storeId:(NSString *)storeId completionBlock:(void (^)(MWUser *user, NSError *))completionBlock
{
    return [[ServerInteractionManager sharedManager] createAccountForUser:user storeId:storeId responseBlock:^(NSDictionary *response, NSError *error) {
        if(error){
            completionBlock(nil,error);
            return;
        }
        user.id = [response objectForKeyOrNilIfNotExists:@"id"];
        completionBlock(user, error);
    }];
}


- (NSOperation*)getAccountsForStoreId: (NSString*) storeId
                      completionBlock: (void (^)(NSArray* users, NSError* error)) completionBlock
{
    return [[ServerInteractionManager sharedManager] getUsersOfStoreId:storeId responseBlock:^(NSArray *users, NSError *error) {
        if (error){
            completionBlock(nil, error);
        }
        else{
            NSMutableArray *usersEntities = [NSMutableArray arrayWithCapacity:users.count];
            for (NSDictionary *userInfo in users) {
                MWUser *user = [[MWUser alloc] initWithJSONDictionary:userInfo];
                [usersEntities addObject:user];
                [user release];
            }
            completionBlock (usersEntities, error);
        }
    }];
}

- (NSOperation *)deleteUserById:(NSNumber *)userId completionBlock:(void (^)(NSError *))completionBlock
{
    return [[ServerInteractionManager sharedManager] deleteUserId:userId responseBlock:^(NSDictionary *response, NSError *error)
    {
        if (completionBlock)
            completionBlock(error);
    }];
}



@end
