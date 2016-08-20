//
//  EntertainmentApplyLiveView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/21.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "EntertainmentApplyLiveView.h"

@interface  EntertainmentApplyLiveView()
@property (nonatomic, strong) UIView *backGroundView;//
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIImageView *topHeaderImageView;
@property (nonatomic, strong) UILabel *blueLabel;
@property (nonatomic, strong) UILabel *lightLabel;

@end
@implementation EntertainmentApplyLiveView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.backGroundView];
    [self addSubview:self.showView];
    [self.showView addSubview:self.topBackgroundView];
    [self.topBackgroundView addSubview:self.topHeaderImageView];
    [self.showView addSubview:self.blueLabel];
    [self.showView addSubview:self.lightLabel];
    [self addButton];
}
- (void)addButton
{
    UIButton *pilotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pilotButton.frame = CGRectMake(25, viewHeight(self.showView)-25 -40, (viewWidth(self.showView)-70)/2, 40);
    [pilotButton setTitle:@"试播" forState:UIControlStateNormal];
    [pilotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    pilotButton.layer.borderWidth = 0.7;
    pilotButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pilotButton.layer.cornerRadius = 15.0f;
    [pilotButton setBackgroundColor:[UIColor whiteColor]];
    [self.showView addSubview:pilotButton];
    
    UIButton *applyLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyLiveButton.frame = CGRectMake(viewWidth(self.showView)-25-viewWidth(pilotButton), viewY(pilotButton), viewWidth(pilotButton), viewHeight(pilotButton));
    [applyLiveButton setTitle:@"申请主播" forState:UIControlStateNormal];
    [applyLiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyLiveButton.layer.cornerRadius = 15.0f;
    [applyLiveButton setBackgroundColor:navigationBarColor];
    [self.showView addSubview:applyLiveButton];
}
- (void)appearView
{
    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.showView.frame = CGRectMake(viewX(self.showView), viewHeight(self)/4, viewWidth(self.showView), viewHeight(self.showView));
        self.backGroundView.alpha = 0.3;
    }];
    [UIView commitAnimations];
}
- (void)hideView
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.showView.frame = CGRectMake(viewX(self.showView),viewHeight(self)+100, viewWidth(self.showView), viewHeight(self.showView));
        self.backGroundView.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
        
    }];
    [UIView commitAnimations];
}
//懒加载
- (UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth(self), viewHeight(self))];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
        [_backGroundView addGestureRecognizer:tap];
    }
    return _backGroundView;
}
- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(20, viewHeight(self)/4, viewWidth(self)-40, viewHeight(self)/2)];
        _showView.backgroundColor = [UIColor whiteColor];
        _showView.clipsToBounds = YES;
        _showView.layer.cornerRadius = 20.0f;
    }
    return _showView;
}
- (UILabel *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,viewHeight(self.topBackgroundView)+ 25, viewWidth(self.showView)-10, 20)];
        _blueLabel.textColor = navigationBarColor;
        _blueLabel.textAlignment = NSTextAlignmentCenter;
        _blueLabel.text = @"您还未申请成为战旗主播";
        _blueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _blueLabel.minimumScaleFactor = 0.5;
        _blueLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _blueLabel;
}
- (UILabel *)lightLabel
{
    if (!_lightLabel) {
        _lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.blueLabel.frame)+10, viewWidth(self.showView)-10, 20)];
        _lightLabel.textColor = [UIColor lightGrayColor];
        _lightLabel.textAlignment = NSTextAlignmentCenter;
        _lightLabel.text = @"点击申请主播 开启直播之旅吧～";
        _lightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _lightLabel.minimumScaleFactor = 0.5;
        _lightLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _lightLabel;
}
- (UIView *)topBackgroundView
{
    if (!_topBackgroundView) {
        _topBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth(self.showView), viewHeight(self.showView)/3)];
        _topBackgroundView.backgroundColor = navigationBarColor;
    }
    return _topBackgroundView;
}
- (UIImageView *)topHeaderImageView
{
    if (!_topHeaderImageView) {
        _topHeaderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Entertainment_applyLiveView"]];
        _topHeaderImageView.frame = CGRectMake(0, viewHeight(self.topBackgroundView)/3-10, viewHeight(self.topBackgroundView)/3*2, viewHeight(self.topBackgroundView)/3*2);
        _topHeaderImageView.center = CGPointMake(viewWidth(self.showView)/2, _topHeaderImageView.center.y);
        _topHeaderImageView.clipsToBounds = YES;
    }
    return _topHeaderImageView;
}
@end
