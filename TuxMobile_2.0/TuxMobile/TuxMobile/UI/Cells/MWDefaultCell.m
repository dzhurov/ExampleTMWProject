//
//  MWDefaultCell.m
//  TuxMobile
//
//  Created by Andrew Denisov on 9/3/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import "MWDefaultCell.h"

@implementation MWDefaultCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithCellIdentifier:(NSString *)cellID {
    return [self initWithStyle:UITableViewCellStyleDefault
               reuseIdentifier:cellID];
}

+ (id)cellForTableView:(UITableView *)tableView {
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithCellIdentifier:cellID];
    }
    return cell;
}

@end
