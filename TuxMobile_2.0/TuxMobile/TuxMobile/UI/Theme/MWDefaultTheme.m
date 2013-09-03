//
//  MWDefaultTheme.m
//  TuxMobile
//
//  Created by Andrew Denisov on 9/3/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import "MWDefaultTheme.h"

@implementation MWDefaultTheme

- (UIColor *)mainColor
{
    return nil;
}

- (UIColor *)highlightColor
{
    return nil;
}

- (UIColor *)shadowColor
{
    return nil;
}

- (UIColor *)backgroundColor
{
    return nil;
}

- (UIColor *)baseTintColor
{
    return nil;
}

- (UIColor *)accentTintColor
{
    return nil;
}

- (UIColor *)switchThumbColor
{
    return nil;
}

- (UIColor *)switchOnColor
{
    return nil;
}

- (UIColor *)switchTintColor
{
    return nil;
}

- (CGSize)shadowOffset
{
    return CGSizeZero;
}

- (UIImage *)topShadow
{
    return nil;
}

- (UIImage *)bottomShadow
{
    return nil;
}

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    return nil;
}

- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics
{
    return nil;
}

- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    return nil;
}

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    return nil;
}

- (UIImage *)searchBackground
{
    return nil;
}

- (UIImage *)searchFieldImage
{
    return nil;
}

- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    return nil;
}

- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state
{
    return nil;
}

- (UIImage *)searchScopeButtonDivider
{
    return nil;
}

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
{
    return nil;
}

- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics
{
    return nil;
}

- (UIImage *)tableBackground
{
    return nil;
}

- (UIImage *)onSwitchImage
{
    return nil;
}

- (UIImage *)offSwitchImage
{
    return nil;
}

- (UIImage *)sliderThumbForState:(UIControlState)state
{
    return nil;
}

- (UIImage *)sliderMinTrack
{
    return nil;
}

- (UIImage *)sliderMaxTrack
{
    return nil;
}

- (UIImage *)speedSliderMinImage
{
    return nil;
}

- (UIImage *)speedSliderMaxImage
{
    return nil;
}

- (UIImage *)progressTrackImage
{
    return nil;
}

- (UIImage *)progressProgressImage
{
    return nil;
}

- (UIImage *)stepperBackgroundForState:(UIControlState)state
{
    return nil;
}

- (UIImage *)stepperDividerForState:(UIControlState)state
{
    return nil;
}

- (UIImage *)stepperIncrementImage
{
    return nil;
}

- (UIImage *)stepperDecrementImage
{
    return nil;
}

- (UIImage *)buttonBackgroundForState:(UIControlState)state
{
    return nil;
}

- (UIImage *)buttonImageForState:(UIControlState)state
{
    UIImage* image = nil;
    
    
    switch (state) {
        case UIControlStateNormal:
            image = [[UIImage imageNamed:@"button_black_gradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
            break;
        
        case UIControlStateHighlighted:
        case UIControlStateSelected:
            image = [[UIImage imageNamed:@"button_black_gradient_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
            break;
        default:
            break;
    }
    
    return image;
}

@end
