//
//  GeneralUIConstants.h
//  GroupManager
//
//  Created by Dmitry Zhurov on 20.09.12.
//  Copyright (c) 2012 Dmitry Zhurov. All rights reserved.
//

#ifndef GroupManager_GeneralUIConstants_h
#define GroupManager_GeneralUIConstants_h

#import <UIKit/UIKit.h>

#define iPhoneScreenSize() [[UIScreen mainScreen] bounds].size

static const CGFloat kStatusBarheight = 20.f;
static const CGFloat kNavigationBarHeight = 44.f;
static const CGFloat kNavigationBarWithPromptHeight = 74.f;
static const CGFloat kIPhoneKeyboardHeight = 216.f;
static const CGFloat kTabBarHeight = 49.f;

// Fonts

#define FONT_GOTHAM_BOOK         @"Gotham-Book"
#define FONT_GOTHAM_BOOK_ITALIC  @"Gotham-BookItalic"
#define FONT_GOTHAM_BOLD         @"Gotham-Bold"
#define FONT_GOTHAM_BOLD_ITALIC  @"Gotham-BoldItalic"
#define FONT_GOTHAM_THIN         @"Gotham-Thin"
#define FONT_GOTHAM_BLACK        @"Gotham-Black"
#define FONT_HELVETICA_REG       @"Helvetica-Regular"
#define FONT(font_name,font_size)    [UIFont fontWithName:font_name size:font_size]

//Colors
#define RGB(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define RGB_255(r,g,b,a) RGB(r/255.0,g/255.0,b/255.0,a)

#define kNavBarGreenColor	RGB(0.408, 0.584, 0.298, 1.0)
#define kLightBlueColor		RGB(0.9, 0.95, 1.0, 1.0)
#define kLightYellowColor	RGB(0.95, 0.95, 0.95, 1.0)
#define kVeryDarkGrayColor  RGB(0.15, 0.15, 0.15, 1.0)
#define kSearchOrderCellTopColor    RGB(0.95, 0.95, 0.95, 1.0)
#define kSearchOrderCellBottomColor RGB(0.6, 0.6, 0.6, 1.0)

#endif
