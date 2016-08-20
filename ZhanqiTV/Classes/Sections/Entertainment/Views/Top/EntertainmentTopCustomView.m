//
//  EntertainmentTopCustomView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "EntertainmentTopCustomView.h"

@interface EntertainmentTopCustomView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nickLabel;
@end
@implementation EntertainmentTopCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.imageView];
    [self addSubview:self.nickLabel];
}
//懒加载
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, viewWidth(self)-20, viewWidth(self)-20)];
        _imageView.layer.cornerRadius = viewWidth(_imageView)/2;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+3, viewWidth(self), 10)];
        _nickLabel.adjustsFontSizeToFitWidth = YES;
        _nickLabel.minimumScaleFactor = 0.5;
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
    return _nickLabel;
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:[UIImage imageNamed:@"default_image"]];
}
- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    self.nickLabel.text = _nickName;
}
@end
