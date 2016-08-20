//
//  LiveCollectionCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LiveCollectionCell.h"
#import "UIView+YZY.h"

@interface LiveCellInfoView : UIView
- (void)refresh:(id)data;
@end
@interface LiveCollectionCell()
@property (nonatomic, strong) UIImageView *coverImageView;//封面
@property (nonatomic, strong) LiveCellInfoView *infoView;
@property (nonatomic, strong) UILabel *titleLabel;//标题

@end
@implementation LiveCollectionCell

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
    [self.coverImageView addSubview:self.titleLabel];
    [self addSubview:self.infoView];
}

- (CGFloat)bottomViewHeight//下面文字所占view高度
{
    return 25.f;
}
- (CGFloat)titleLabelHeight
{
    return 14.f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverImageView.size = CGSizeMake(self.width, self.height-self.bottomViewHeight);
    self.titleLabel.bottom = self.coverImageView.height;
    self.titleLabel.width = self.coverImageView.width;
    self.infoView.bottom = self.height;
}
//TODO:懒加载
- (LiveCellInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[LiveCellInfoView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.bottomViewHeight)];
        _infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _infoView;
}
- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//自动调整自己的宽高，保证与父视图左右边以及顶部底部距离不变
    }
    return _coverImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, self.titleLabelHeight)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (void)resetRoomsModel:(LiveRooms *)model
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
    self.titleLabel.text = model.title;//标题
    [self.infoView refresh:model];
}

@end

@interface LiveCellInfoView()
@property (nonatomic, strong) UILabel *nickLabel;//主播名
@property (nonatomic, strong) UIImageView *genderImageView;//性别图
@property (nonatomic, strong) UIImageView *audienceImageView;//观众图
@property (nonatomic, strong) UILabel *audienceLabel;//观众人数
@end
@implementation LiveCellInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.genderImageView];
        [self addSubview:self.audienceLabel];
        [self addSubview:self.audienceImageView];
        [self addSubview:self.nickLabel];
    }
    return self;
}

- (CGFloat)controlHeight
{
    return 15.f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat top = 5.f;
    self.genderImageView.top = top;
    self.audienceLabel.centerY = self.genderImageView.centerY;
    self.audienceLabel.right = self.right;
    self.audienceImageView.centerY = self.genderImageView.centerY;
    self.audienceImageView.right = self.audienceLabel.left;
    self.nickLabel.centerY = self.genderImageView.centerY;
    self.nickLabel.right = self.audienceImageView.left;
    self.nickLabel.left = self.genderImageView.right;
}
- (void)refresh:(id)data
{
    if ([data isKindOfClass:[LiveRooms class]]) {
        LiveRooms *model = (LiveRooms *)data;
        //1为性别女,2为性别男
        NSString *imageName = [model.gender isEqualToString:@"1"] ? @"default_woman" : @"default_man";
        self.genderImageView.image = [UIImage imageNamed:imageName];
        
        self.nickLabel.text = model.nickname;//主播名
        //如果观众大于等于1w 用单位万，更新ui frame，否则用正常观众人数
        NSInteger onLineInteger = [model.online integerValue];
        if (onLineInteger < 10000) {
            self.audienceLabel.text = model.online;
        }
        else
        {
            NSString *fixOnlineString = [model.online substringWithRange:NSMakeRange(0, model.online.length - 4)];
            NSString *endOfString = [model.online substringWithRange:NSMakeRange(model.online.length - 4, 1)];
            fixOnlineString = [fixOnlineString stringByAppendingFormat:@".%@万",endOfString];
            self.audienceLabel.text = fixOnlineString;
        }
        [self.audienceLabel sizeToFit];
        [self.nickLabel sizeToFit];
    }
}
- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nickLabel.textColor = [UIColor lightGrayColor];
        _nickLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickLabel;
}
- (UIImageView *)audienceImageView
{
    if (!_audienceImageView) {
        _audienceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, self.controlHeight)];
        _audienceImageView.image = [UIImage imageNamed:@"home_audience"];
    }
    return _audienceImageView;
}
- (UILabel *)audienceLabel
{
    if (!_audienceLabel) {
        _audienceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _audienceLabel.textColor = [UIColor lightGrayColor];
        _audienceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _audienceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _audienceLabel;
}
- (UIImageView *)genderImageView
{
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    }
    return _genderImageView;
}
@end