//
//  BarragePositionCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "BarragePositionCell.h"

@interface BarragePositionCell()
@property (nonatomic, strong) UILabel *label;//标题

@end
@implementation BarragePositionCell

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
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, kScreen_width/2-12, 25)];
        _label.text = @"弹幕位置";
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        CGFloat firstButtonX = kScreen_width - (40*3+10*2+12);
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            switch (i) {
                case 0:
                    [button setImage:[UIImage imageNamed:@"setup_setting_shangfgang_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_shangfang_highlight"] forState:UIControlStateSelected];
                    break;
                case 1:
                    button.selected = YES;
                    [button setImage:[UIImage imageNamed:@"setup_setting_quanping_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_quanping_highlight"] forState:UIControlStateSelected];
                    break;
                case 2:
                    [button setImage:[UIImage imageNamed:@"setup_setting_xiafang_normal"] forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:@"setup_setting_xiafang_highlight"] forState:UIControlStateSelected];
                    break;
                default:
                    break;
            }
            button.frame = CGRectMake(firstButtonX+i*(40+10), viewY(_label), 40, 50);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }
    }
    return _label;
}
- (void)buttonAction:(UIButton *)sender
{
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
