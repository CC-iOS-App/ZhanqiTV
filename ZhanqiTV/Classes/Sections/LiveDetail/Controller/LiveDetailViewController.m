//
//  LiveDetailViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LiveDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LandscapePlayerView.h"
#import "InputView.h"
#import "UIConfig.h"
#import "UIView+YZY.h"
#import "SessionCofig.h"
#import "InputSessionConfig.h"
#import "LiveDetailKindView.h"
#import "UIView+YZY.h"
@interface LiveDetailViewController ()<InputActionDelegate>
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) LandscapePlayerView *playerView;
@property (nonatomic, weak) id<SessionCofig> config;
@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) InputSessionConfig *sessionConfig;
@property (nonatomic, strong) LiveDetailKindView *kindView;//排行等
@end

@implementation LiveDetailViewController

//视图将要出现时，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self getBroadcastAddress];//获取视频播放地址
    [self initView];//建立view
}
- (void)getBroadcastAddress
{
    NSString *filePath = [[[NSString alloc]initWithString:  [NSString stringWithFormat:@"%@%@.m3u8",HLS_URL,_videoId]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *videoUrl = [NSURL URLWithString:filePath];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    //释放
    [self.avPlayer.currentItem canUseNetworkResourcesForLiveStreamingWhilePaused];
}
- (void)initView
{
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.kindView];
    [self.view addSubview:self.inputView];
}

- (id<SessionCofig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[InputSessionConfig alloc]init];
    };
    return _sessionConfig;
}
#define KindViewHeight  44
//TODO:懒加载
- (InputView *)inputView
{
    if (!_inputView) {
        CGRect inputViewRect = CGRectMake(0, 0, self.view.width, [UIConfig topInputViewHeight]);
        _inputView = [[InputView alloc]initWithFrame:inputViewRect];
        _inputView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _inputView.bottom = self.view.height;
        [_inputView setInputConfig:[self sessionConfig]];
        [_inputView setInputActionDelegate:self];
    }
    return _inputView;
}
- (LiveDetailKindView *)kindView
{
    if (!_kindView) {
        _kindView = [[LiveDetailKindView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, KindViewHeight)];
        _kindView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _kindView.top = self.playerView.bottom;
        
    }
    return _kindView;
}
- (LandscapePlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[LandscapePlayerView alloc]initWithFrame:CGRectMake(0, 20, kScreen_width, 175*kScreenFactor)];
        _playerView.player = _avPlayer;
        _playerView.viewController = self;
        [_playerView.player play];
    }
    return _playerView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            if ([playerItem status] == AVPlayerStatusReadyToPlay)  {
                NSLog(@"AVPlayerStatusReadyToPlay");
            }
            else if ([playerItem status] == AVPlayerStatusFailed)
            {
                NSLog(@"AVPlayerStatusFailed");
            }
        }
        else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除监听
    if (self.playerView.player.rate == 1) {
        [self.playerView.player pause];
    }
    self.playerView.player = nil;
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    self.navigationController.navigationBar.hidden = NO;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
