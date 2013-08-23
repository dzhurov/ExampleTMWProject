//
//  UIAlertView+Block.m
//  Tailoring
//
//  Created by Dmitry Zhurov on 15.01.13.
//  Copyright (c) 2013 Dmitry Zhurov. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static NSString *ZD_BLOCK_ASS_KEY = @"com.zd.COMPLETION_BLOCK";

@implementation UIAlertView (Block)

- (id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage completionBlock:(void (^)(UIAlertView *, NSInteger))completionBlock cancelButtonTitle:(NSString *)inCancelButtonItem otherButtonTitles:(NSString *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION
{
    if((self = [self initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inCancelButtonItem otherButtonTitles:inOtherButtonItems, nil]))
    {        
        NSString *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, NSString *)))
            {
                [self addButtonWithTitle:eachItem];
            }
            va_end(argumentList);
        }

        objc_setAssociatedObject(self, (const void *)ZD_BLOCK_ASS_KEY, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [self setDelegate:self];
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^completionBlock)(UIAlertView *, NSInteger) = objc_getAssociatedObject(self, (const void *)ZD_BLOCK_ASS_KEY);
    if (completionBlock)
        completionBlock(alertView, buttonIndex);
    
    objc_setAssociatedObject(self, (const void *)ZD_BLOCK_ASS_KEY, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
