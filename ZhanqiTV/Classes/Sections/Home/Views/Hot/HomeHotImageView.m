//
//  HomeHotImageView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/15.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeHotImageView.h"
@interface HomeHotImageView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *liveTitleLable;
@property (nonatomic, strong) UILabel *nickNameLabel;
@end
@implementation HomeHotImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)  return nil;
    [self setup];
    return self;
}
- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    self.nickNameLabel.text = _nickName;
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:[UIImage imageNamed:@"default_image"]];
}
- (void)setLiveTitle:(NSString *)liveTitle
{
    _liveTitle = liveTitle;
    self.liveTitleLable.text = _liveTitle;
}

- (void)setup
{
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.nickNameLabel];
    [self.imageView addSubview:self.liveTitleLable];
}
//懒加载
- (UILabel *)liveTitleLable
{
    if (!_liveTitleLable) {
        _liveTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, viewY(self.nickNameLabel)-14, viewWidth(self.imageView), 14)];
        _liveTitleLable.textColor = [UIColor whiteColor];
        _liveTitleLable.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _liveTitleLable.textAlignment = NSTextAlignmentLeft;
    }
    return _liveTitleLable;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth(self), viewHeight(self))];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, viewHeight(self.imageView)-12, viewWidth(self.imageView), 12)];
        _nickNameLabel.textColor = navigationBarColor;
        _nickNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _nickNameLabel.alpha = 0.8;
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}
@end
