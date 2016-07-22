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
@interface LiveDetailViewController ()
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) LandscapePlayerView *playerView;
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
}
- (void)initView
{
    [self.view addSubview:self.playerView];
}
//TODO:懒加载
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
