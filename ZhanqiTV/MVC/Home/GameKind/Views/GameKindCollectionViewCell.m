//
//  GameKindCollectionViewCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/15.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "GameKindCollectionViewCell.h"

@interface GameKindCollectionViewCell()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation GameKindCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.coverImageView];
    [self addSubview:self.nameLabel];
}
//懒加载
- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth(self), 130*kScreenFactor)];
    }
    return _coverImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewX(self.coverImageView), CGRectGetMaxY(self.coverImageView.frame), viewWidth(self.coverImageView), 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _nameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

//加载数据
- (void)resetGamesModel:(GameKindGames *)model
{
    NSString *urlString;
    if (![model.spic isEqualToString:@""]) {
        urlString = model.spic;
    }
    else
    {
        urlString = model.bpic;
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.nameLabel.text = model.name;
}
@end
