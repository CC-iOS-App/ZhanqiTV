//
//  SetupSwitchCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/1.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "SetupSwitchCell.h"
#import "CommonTableData.h"
#import "UIView+YZY.h"
@interface SetupSwitchCell()

@property (nonatomic, strong) UISwitch *switcher;
@end
@implementation SetupSwitchCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _switcher = [[UISwitch alloc]initWithFrame:CGRectZero];
        self.accessoryView = _switcher;
//        [self addSubview:_switcher];
    }
    return self;
}

- (void)refreshData:(CommonTableRow *)rowData tableView:(UITableView *)tableView
{
    self.textLabel.text         = rowData.title;
    self.detailTextLabel.text   = rowData.detailTitle;
    NSString *actionName        = rowData.cellActionName;
    [self.switcher setOn:[rowData.extraInfo boolValue] animated:YES];
    [self.switcher removeTarget:self.viewController action:NULL forControlEvents:UIControlEventValueChanged];
    if (actionName.length) {
        SEL sel = NSSelectorFromString(actionName);
        [self.switcher addTarget:tableView.viewController action:sel forControlEvents:UIControlEventValueChanged];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
