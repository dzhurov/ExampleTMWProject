//
//  MWNavigationManager.m
//  GroupManager
//
//  Created by Dmitry Zhurov on 26.09.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import "MWNavigationManager.h"
#import "MWLoginViewController.h"

@interface MWNavigationManager ()

@property (nonatomic, retain) NSString *currentGarmentId;

@end

@implementation MWNavigationManager

@dynamic rootViewController;
@dynamic currentTabViewController;

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(MWNavigationManager, sharedNavigationManager);

- (id)init
{
    self = [super init];
    if (self) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
        [self.window makeKeyAndVisible];
    }
    return self;
}

- (UIViewController *)rootViewController
{
    return self.window.rootViewController;
}


#pragma mark - navigation

- (void)showFirstViewController
{
    MWLoginViewController* loginVC = [MWLoginViewController new];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
}

#pragma mark - activity indicator

- (void) showActivityIndicatorWithLabel:(NSString *)label
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//    hud.labelText = label;
}

- (void)hideActivityIndicator
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    while ([MBProgressHUD hideHUDForView:self.window animated:YES]);
}

@end
