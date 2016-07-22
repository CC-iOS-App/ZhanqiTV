//
//  EntertainmentTalentShowCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "EntertainmentTalentShowCell.h"

@interface EntertainmentTalentShowCell()
@property (nonatomic, strong) NSString *audience;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *audienceLabel;
@property (nonatomic, strong) UIImageView *audienceImageView;
@property (nonatomic, strong) UIView *audienceBackgroundView;
@end
@implementation EntertainmentTalentShowCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.showImageView];
    [self.showImageView addSubview:self.nickNameLabel];
    [self.showImageView addSubview:self.audienceBackgroundView];
    [self.showImageView addSubview:self.audienceLabel];
    [self.showImageView addSubview:self.audienceImageView];
    
}
//设置数据
- (void)resetModel:(EntertainmentOtherList *)model
{
    NSString *urlString;
    if (![model.spic isEqualToString:@""]) {//判断spic有没图片地址，没有就用bpic
        urlString = model.spic;
    }
    else
    {
        urlString = model.bpic;
    }
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"default_image"]];//封面
    self.nickNameLabel.text = model.nickname;
    self.audience = model.online;
}
- (void)setAudience:(NSString *)audience
{
    _audience = audience;
    NSInteger onLineInteger = [_audience integerValue];
    if (onLineInteger < 10000) {
        self.audienceLabel.text = _audience;
        [self updateOnlineFrame:_audience];
    }
    else
    {
        NSString *fixOnlineString = [_audience substringWithRange:NSMakeRange(0, _audience.length - 4)];
        NSString *endOfString = [_audience substringWithRange:NSMakeRange(_audience.length - 4, 1)];
        fixOnlineString = [fixOnlineString stringByAppendingFormat:@".%@万",endOfString];
        self.audienceLabel.text = fixOnlineString;
        [self updateOnlineFrame:fixOnlineString];
    }
}
//根据观看人数调整view
- (void)updateOnlineFrame:(NSString *)string
{
    CGSize size = [Tool getStringSize:string withWidth:MAXFLOAT withHeight:15 withFontName:UIFontTextStyleCaption2];
    
    self.audienceLabel.frame = CGRectMake(viewWidth(self.showImageView)-size.width-6, 6, size.width, size.height);
    
    self.audienceImageView.frame = CGRectMake(viewX(self.audienceLabel)-20, viewY(self.audienceLabel), 15, 15);
    self.audienceBackgroundView.frame = CGRectMake(viewX(self.audienceImageView)-2, 3,viewWidth(self.showImageView)-viewX(self.audienceImageView), viewHeight(self.audienceLabel)+6);
}
//TODO:懒加载
- (UIImageView *)showImageView
{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, kScreen_width/2-9, 146*kScreenFactor)];
    }
    return _showImageView;
}
- (UIImageView *)audienceImageView
{
    if (!_audienceImageView) {
        _audienceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_talentShow"]];
    }
    return _audienceImageView;
}
- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, viewHeight(self.showImageView)-20, viewWidth(self.showImageView)-10, 15)];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
    return _nickNameLabel;
}
- (UILabel *)audienceLabel
{
    if (!_audienceLabel) {
        _audienceLabel = [[UILabel alloc]init];
        _audienceLabel.textColor = [UIColor whiteColor];
        _audienceLabel.textAlignment = NSTextAlignmentRight;
        _audienceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    }
    return _audienceLabel;
}
- (UIView *)audienceBackgroundView
{
    if (!_audienceBackgroundView) {
        _audienceBackgroundView = [[UIView alloc]init];
        _audienceBackgroundView.alpha = 0.6;
        _audienceBackgroundView.backgroundColor = [UIColor blackColor];
        _audienceBackgroundView.layer.cornerRadius = 3.0f;
    }
    return _audienceBackgroundView;
}
@end
