//
//  MWAccountManager.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 08.11.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "AccountManager.h"
#import "ServerInteractionManager.h"
#import "Notifications.h"
#import "LoginRequest.h"
#import "LoginResponse.h"
#import "User.h"

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
        self.user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData: user];
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey] ;
        
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
    LoginRequest *loginEntity = [LoginRequest new];
    loginEntity.userId = login;
    loginEntity.password = password;
    [[ServerInteractionManager sharedManager] userLogin:[loginEntity dictionaryInfo] responseBlock:^(NSDictionary *loginResponse, NSError *error) {
        if (error){
            completionBlock(error);
            return;
        }
        else{
            _token = [loginResponse objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kTokenKey];
            NSString *expDateString = [loginResponse objectForKey:@"expirationDate"] ;
            _expirationDate = [[NSDateFormatter yearMonthDayAndTimeDateFormatter] dateFromString:expDateString];
            [[NSUserDefaults standardUserDefaults] setObject:_expirationDate forKey:kExpirationDateKey];
            User *user = [[User alloc] initWithDictionaryInfo:[loginResponse objectForKey:@"user"]];
            self.user = user;
            NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:kEncodedUserKey];
            
            [[NSUserDefaults standardUserDefaults] setObject:login forKey:kLoginKey];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordKey];
                        
            completionBlock(nil);
        }
    }];
}

- (BOOL)reloginSynchronous:(NSError **)error
{
    if ([self userHasBeenLoggedIn]){
        NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
        LoginRequest *loginEntity = [LoginRequest new];
        loginEntity.userId = login;
        loginEntity.password = password;
        // 
        NSDictionary *loginResponseDict = [[ServerInteractionManager sharedManager] synchronousLogin:[loginEntity dictionaryInfo] error:error];
        if (*error){
            return NO;
        }
        else{
            NSString *token = [loginResponseDict objectForKey:@"token"];
            if (token.length){
                _token = token ;
                [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kTokenKey];
                NSString *expdateString = [loginResponseDict objectForKey:@"expirationDate"];
                _expirationDate = [[NSDateFormatter yearMonthDayAndTimeDateFormatter] dateFromString:expdateString] ;
                [[NSUserDefaults standardUserDefaults] setObject:_expirationDate forKey:kExpirationDateKey];
                
                User *user = [[User alloc] initWithDictionaryInfo:[loginResponseDict objectForKey:@"user"]];
                self.user = user;
                NSData *encodedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:encodedUser forKey:kEncodedUserKey];
                
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
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    }
    return _token;
}

- (NSDate *)expirationDate
{
    if (!_expirationDate){
        _expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kExpirationDateKey];
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


@end
