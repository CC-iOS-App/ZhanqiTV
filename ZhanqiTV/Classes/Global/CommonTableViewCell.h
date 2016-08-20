//
//  CommonTableViewCell.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/1.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommonTableRow;

@protocol CommonTableViewCell <NSObject>

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@optional
- (void)refreshData:(CommonTableRow *)rowData tableView:(UITableView *)tableView;
@end
