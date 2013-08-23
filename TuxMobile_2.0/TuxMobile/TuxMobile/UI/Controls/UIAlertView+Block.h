//
//  UIAlertView+Block.h
//  Tailoring
//
//  Created by Dmitry Zhurov on 15.01.13.
//  Copyright (c) 2013 Dmitry Zhurov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block) <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void(^)(UIAlertView* alertView, NSInteger selectedButtonIndex))completionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
