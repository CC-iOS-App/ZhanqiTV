//
//  BarrageSize.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "BarrageSizeCell.h"
#import "CommonTableData.h"
#import "CommonTableViewCell.h"
#import "UIView+YZY.h"
@interface BarrageSizeCell()<CommonTableViewCell>

@property (nonatomic, strong) UILabel *label;//标题
@property (nonatomic, strong) UILabel *styleLabel;//样式显示
@end
@implementation BarrageSizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.label];
    [self addSubview:self.styleLabel];
}
- (void)refreshData:(CommonTableRow *)rowData tableView:(UITableView *)tableView
{
    self.label.text = rowData.title;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, kScreen_width/2-12, 25)];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        CGFloat firstButtonX = kScreen_width - (40*3+10*2+12);
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            switch (i) {
                case 0:
                    [button setImage:[UIImage imageNamed:@"setup_setting_xiao_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_xiao_highlight"] forState:UIControlStateSelected];
                    break;
                case 1:
                    button.selected = YES;
                    [button setImage:[UIImage imageNamed:@"setup_setting_zhong_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_zhong_highlight"] forState:UIControlStateSelected];
                    break;
                case 2:
                    [button setImage:[UIImage imageNamed:@"setup_setting_da_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_da_highlight"] forState:UIControlStateSelected];
                    break;
                default:
                    break;
            }
            button.frame = CGRectMake(firstButtonX+i*(40+10), 10, 40, 50);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }
    }
    return _label;
}
- (UILabel *)styleLabel
{
    if (!_styleLabel) {
        _styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.label.left,70, kScreen_width-self.label.left*2, 40)];
        _styleLabel.layer.cornerRadius = 10.0f;
        _styleLabel.backgroundColor = navigationBarColor;
        _styleLabel.textAlignment = NSTextAlignmentCenter;
        _styleLabel.textColor = [UIColor whiteColor];
        _styleLabel.text = @"弹幕预览，这效果怎么样？";
        _styleLabel.clipsToBounds = YES;
    }
    return _styleLabel;
}
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            self.styleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            break;
        case 1:
            self.styleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
            break;
        case 2:
            self.styleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
            break;
        default:
            break;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button == sender) {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
