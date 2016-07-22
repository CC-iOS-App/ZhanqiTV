//
//  LandscapePlayerView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/21.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LandscapePlayerView.h"

@interface LandscapePlayerView()
@property (nonatomic, strong) UIImageView *returnImageView;//返回
@property (nonatomic, strong) UIImageView *shareImageView;//分享
@property (nonatomic, strong) UIImageView *landscapeamplificationImageView;//横屏放大
@end
@implementation LandscapePlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.returnImageView];
    [self addSubview:self.landscapeamplificationImageView];
    [self addSubview:self.shareImageView];
}

- (void)plyaerTap:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:
            [_viewController.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}
//懒加载
- (UIImageView *)landscapeamplificationImageView
{
    if (!_landscapeamplificationImageView) {
        _landscapeamplificationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LiveDetail_fullscreen"]];
        _landscapeamplificationImageView.frame = CGRectMake(viewWidth(self)-10-viewWidth(self.returnImageView),viewHeight(self)-10-viewHeight(self.returnImageView), viewWidth(self.returnImageView), viewHeight(self.returnImageView));
        _landscapeamplificationImageView.userInteractionEnabled = YES;
        _landscapeamplificationImageView.tag = 3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plyaerTap:)];
        [_landscapeamplificationImageView addGestureRecognizer:tap];
    }
    return _landscapeamplificationImageView;
}
- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LiveDetail_fullscreen"]];
        _shareImageView.frame = CGRectMake(viewX(self.landscapeamplificationImageView), viewY(self.landscapeamplificationImageView)-20-viewHeight(self.landscapeamplificationImageView), viewWidth(self.landscapeamplificationImageView), viewHeight(self.landscapeamplificationImageView));
        _shareImageView.userInteractionEnabled = YES;
        _shareImageView.tag = 2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plyaerTap:)];
        [_shareImageView addGestureRecognizer:tap];
    }
    return _shareImageView;
}
- (UIImageView *)returnImageView
{
    if (!_returnImageView) {
        _returnImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LiveDetail_back_s"]];
        _returnImageView.frame = CGRectMake(10, 10, 40, 40);
        _returnImageView.userInteractionEnabled = YES;
        _returnImageView.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(plyaerTap:)];
        [_returnImageView addGestureRecognizer:tap];
    }
    return _returnImageView;
}
//播放设置
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}
- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end
