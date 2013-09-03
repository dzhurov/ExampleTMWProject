//
//  MWDefaultCell.h
//  TuxMobile
//
//  Created by Andrew Denisov on 9/3/13.
//  Copyright (c) 2013 The Men's Wearhouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWDefaultCell : UITableViewCell

+ (id)cellForTableView:(UITableView *)tableView;
+ (NSString *)cellIdentifier;
- (id)initWithCellIdentifier:(NSString *)cellID;

@end
