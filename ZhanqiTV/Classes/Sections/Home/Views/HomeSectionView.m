//
//  HomeSectionView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/12.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeSectionView.h"
@interface HomeSectionView()

@property (nonatomic, strong) UILabel *titleLabel;//分类名
@property (nonatomic, strong) UIImageView *leftImageView;//左边图片


@property (nonatomic, strong) UILabel *rightLabel;//右边文字，更多或者换一批
@property (nonatomic, strong) UIImageView *rightImageView;//右边图片
@end
@implementation HomeSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.rightImageView];
    [self.headerView addSubview:self.rightLabel];
}
- (void)resetTitle:(HomeListModel *)model
{
    
    if ([model.title isEqualToString:@"热门直播"]) {
        [self defaultShow];
        [self refrshView];
    }
    else if ([model.title isEqualToString:@"达人美拍"])
    {
        [self TalentShow];
        [self moreView];
    }
    else
    {
        [self defaultShow];
        [self moreView];
    }
    self.titleLabel.text = model.title;
}
//热门直播专用右边
- (void)refrshView
{
    self.rightLabel.frame = CGRectMake(30, 0, 40, 15);
    self.rightLabel.text = @"换一批";

    self.rightImageView.image = [UIImage imageNamed:@"home_reommend_refresh"];
    self.rightImageView.frame = CGRectMake(15, 0, 15, 15);
    
    self.headerView.frame = CGRectMake(self.frame.size.width - 85, 20, 85, 15);
}
//其它直播右边view
- (void)moreView
{
    self.rightImageView.image = [UIImage imageNamed:@"home_more"];
    self.rightImageView.frame = CGRectMake(55, 0, 10, 10);
    
    self.rightLabel.frame = CGRectMake(10, 0, 40, CGRectGetHeight(self.rightImageView.frame));
    self.rightLabel.text = @"更多";

    self.headerView.frame = CGRectMake(self.frame.size.width-80, 20, 65, 10);
}
//达人没拍专用左边view
- (void)TalentShow
{
    self.leftImageView.image = [UIImage imageNamed:@"default_image"];
    self.leftImageView.frame = CGRectMake(5, 20, 20, 15);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+5, CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
}
//其它直播专用左边view
- (void)defaultShow
{
    self.leftImageView.image = [UIImage imageNamed:@"home_left_icon"];
    self.leftImageView.frame = CGRectMake(5, 20, 2, 15);
    self.titleLabel.frame = CGRectMake(12, 20, kScreen_width/3, 15);
}
//TODO:懒加载
- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
    }
    return _leftImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
    return _titleLabel;
}
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
    }
    return _rightImageView;
}
- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        
    }
    return _headerView;
}
@end
