//
//  MWTheme.h
//  TuxMobile
//
//  Created by Andrew Denisov on 9/3/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWTheme <NSObject>

- (UIColor *)mainColor;
- (UIColor *)highlightColor;
- (UIColor *)shadowColor;
- (UIColor *)backgroundColor;

- (UIColor *)baseTintColor;
- (UIColor *)accentTintColor;

- (UIColor *)switchThumbColor;
- (UIColor *)switchOnColor;
- (UIColor *)switchTintColor;

- (CGSize)shadowOffset;

- (UIImage *)topShadow;
- (UIImage *)bottomShadow;

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics;

- (UIImage *)searchBackground;
- (UIImage *)searchFieldImage;
- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state;
- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state;
- (UIImage *)searchScopeButtonDivider;

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)tableBackground;

- (UIImage *)onSwitchImage;
- (UIImage *)offSwitchImage;

- (UIImage *)sliderThumbForState:(UIControlState)state;
- (UIImage *)sliderMinTrack;
- (UIImage *)sliderMaxTrack;
- (UIImage *)speedSliderMinImage;
- (UIImage *)speedSliderMaxImage;

- (UIImage *)progressTrackImage;
- (UIImage *)progressProgressImage;

- (UIImage *)stepperBackgroundForState:(UIControlState)state;
- (UIImage *)stepperDividerForState:(UIControlState)state;
- (UIImage *)stepperIncrementImage;
- (UIImage *)stepperDecrementImage;

- (UIImage *)buttonBackgroundForState:(UIControlState)state;

- (UIImage *)buttonImageForState:(UIControlState)state;

@end

@interface MWThemeManager : NSObject

+ (id <MWTheme>)sharedTheme;

+ (void)customizeAppAppearance;
+ (void)customizeView:(UIView *)view;
+ (void)customizeTableView:(UITableView *)tableView;
+ (void)customizeButton:(UIButton *)button;

@end
