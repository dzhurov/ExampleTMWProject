//
//  MWNavigationManager.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 26.09.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface MWNavigationManager : NSObject <UIAlertViewDelegate>

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(MWNavigationManager, sharedNavigationManager);

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, readonly) UIViewController *currentTabViewController;


- (void)showFirstViewController;

// activity
- (void)showActivityIndicatorWithLabel:(NSString *)label;
- (void)hideActivityIndicator;

@end
