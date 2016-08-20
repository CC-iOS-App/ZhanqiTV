//
//  HomeCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeCell.h"
@interface HomeCell()
@property (nonatomic, strong) UIImageView *coverImageView;//封面
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *nickLabel;//主播名
@property (nonatomic, strong) UIImageView *genderImageView;//性别图
@property (nonatomic, strong) UIImageView *audienceImageView;//观众图
@property (nonatomic, strong) UILabel *audienceLabel;//观众人数
@end
@implementation HomeCell

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
    [self addSubview:self.genderImageView];
    [self.coverImageView addSubview:self.titleLabel];
    [self addSubview:self.audienceLabel];
    [self addSubview:self.audienceImageView];
    [self addSubview:self.nickLabel];
}
//更新ui位置
- (void)updateOnlineFrame:(NSString *)string
{
    CGSize size = [Tool getStringSize:string withWidth:MAXFLOAT withHeight:15 withFontName:UIFontTextStyleCaption2];
    
    self.audienceLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame)-size.width, self.audienceLabel.frame.origin.y, size.width, size.height);
    
    self.audienceImageView.frame = CGRectMake(CGRectGetMinX(self.audienceLabel.frame)-20, self.audienceImageView.frame.origin.y, size.height+5, size.height);
    self.nickLabel.frame = CGRectMake(CGRectGetMaxX(self.genderImageView.frame), CGRectGetMinY(self.genderImageView.frame), CGRectGetMinX(self.audienceImageView.frame)- CGRectGetMaxX(self.genderImageView.frame), CGRectGetHeight(self.genderImageView.frame));
}
//TODO:懒加载
- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, kScreen_width/2-9, 85*kScreenFactor)];
    }
    return _coverImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.coverImageView.frame)-14, self.coverImageView.frame.size.width, 14)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.textColor = [UIColor lightGrayColor];
        _nickLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickLabel;
}
- (UIImageView *)audienceImageView
{
    if (!_audienceImageView) {
        _audienceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_audience"]];
        _audienceImageView.frame = CGRectMake(CGRectGetMinX(self.audienceLabel.frame) - 20, CGRectGetMinY(self.genderImageView.frame), 20, CGRectGetHeight(self.genderImageView.frame));
    }
    return _audienceImageView;
}
- (UILabel *)audienceLabel
{
    if (!_audienceLabel) {
        _audienceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-40, CGRectGetMinY(self.genderImageView.frame), 40, CGRectGetHeight(self.genderImageView.frame))];
        _audienceLabel.textColor = [UIColor lightGrayColor];
        _audienceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _audienceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _audienceLabel;
}
- (UIImageView *)genderImageView
{
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.coverImageView.frame), CGRectGetMaxY(self.coverImageView.frame)+5, 15, 15)];
    }
    return _genderImageView;
}
//TODO:model
- (void)resetModel:(List *)model
{
    NSString *urlString;
    if (![model.spic isEqualToString:@""]) {//判断bpic有没图片地址，没有就用spic
        urlString = model.spic;
    }
    else
    {
        urlString = model.bpic;
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"default_image"]];//封面
    if ([model.gender isEqualToString:@"1"]) { //1为性别女
        self.genderImageView.image = [UIImage imageNamed:@"default_woman"];
    }
    else if ([model.gender isEqualToString:@"2"])//2为性别男
    {
        self.genderImageView.image = [UIImage imageNamed:@"default_man"];
    }
    self.nickLabel.text = model.nickname;//主播名
    
    //如果观众大于等于1w 用单位万，更新ui frame，否则用正常观众人数，更新ui frame
    NSInteger onLineInteger = [model.online integerValue];
    if (onLineInteger < 10000) {
        self.audienceLabel.text = model.online;
        [self updateOnlineFrame:model.online];
    }
    else
    {
        NSString *fixOnlineString = [model.online substringWithRange:NSMakeRange(0, model.online.length - 4)];
        NSString *endOfString = [model.online substringWithRange:NSMakeRange(model.online.length - 4, 1)];
        fixOnlineString = [fixOnlineString stringByAppendingFormat:@".%@万",endOfString];
        self.audienceLabel.text = fixOnlineString;
        [self updateOnlineFrame:fixOnlineString];
    }
}
@end
