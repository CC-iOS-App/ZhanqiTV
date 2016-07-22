//
//  GameKindViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
static const NSUInteger PAGE_SIZE = 12;  //一页显示数据数量

#import "GameKindViewController.h"
#import "ZhanqiTVHeader.pch"
#import "GameKindCollectionViewCell.h"
#import "GameKindGamesModel.h"
#define GameKindCollectionCell @"gameKindCollectionCell"
@interface GameKindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    NSUInteger _needWaitTime;   //时间
    
    NSMutableArray *_gameKindArray;//请求回来的数据
    
    NSUInteger currenPage;//当前页
    NSUInteger totalNumber;//总页数
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation GameKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildView];//建立页面
}
#pragma mark -- 初始化View
- (void)buildView
{
    _gameKindArray = [[NSMutableArray alloc]init];//初始化存储数据的数组
    [self.view addSubview:self.collectionView];
    [self setUpCollectionView];
}
//设置collectionView刷新
- (void)setUpCollectionView
{
    currenPage = 1;//默认当前页为1；
    //默认为下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomeData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
    //添加上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    
    _needWaitTime = 120;
    [self setNetworkingRequestInterval];
}
//设置网络请求时间间隔
- (void)setNetworkingRequestInterval
{
    NSTimeInterval period = 1.0;//设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{//执行事件
        _needWaitTime ++;
    });
    dispatch_resume(_timer);//
}
#pragma mark -- 获取请求返回的数据
- (void)getHomeData
{
    //如果请求间隔超过默认请求时间，执行网络请求，否则不请求
    if (_needWaitTime >= NetworkRequestInterval) {
        _needWaitTime = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getGameKindData];//直播类型数据
            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                
            });
        });
    }
    else
    {
        //默认延后一段时间结束刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            //结束刷新
            if (_gameKindArray.count > PAGE_SIZE) {
                NSMutableArray *newArray = [[NSMutableArray alloc]init];
                for (int a = 0; a < _gameKindArray.count; a++) {
                    [newArray addObject:[_gameKindArray objectAtIndex:a]];
                }
                [_gameKindArray removeAllObjects];
                for (int i = 0; i < PAGE_SIZE ; i++) {
                    
                    [_gameKindArray addObject:[newArray objectAtIndex:i]];
                }
                [self.collectionView reloadData];
            }
            [self.collectionView.mj_header endRefreshing];
        });
    }
}
//获取直播类型数据
- (void)getGameKindData
{
    NSString *url = [NSString stringWithFormat:@"static/game.lists/12-%ld.json",currenPage];
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        if (_gameKindArray.count) {
            [_gameKindArray removeAllObjects];
        }
        GameKindSuperGamesModel *gameKindSuperModel = [[GameKindSuperGamesModel alloc]initWithDictionary:responseBody error:nil];
        if ([gameKindSuperModel.code intValue] == 0) {
            totalNumber = [gameKindSuperModel.data.cnt integerValue]/PAGE_SIZE+1;
            
            for (int i = 0; i < gameKindSuperModel.data.games.count; i++) {
                GameKindGames *games = (GameKindGames *)gameKindSuperModel.data.games[i];
                [_gameKindArray addObject:games];
            }
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
//上拉加载
- (void)upRefreshData
{
    if (currenPage < totalNumber) {
        currenPage ++;
        NSString *url = [NSString stringWithFormat:@"static/game.lists/12-%ld.json",currenPage];
        [self.collectionView.mj_footer beginRefreshing];
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            
            GameKindSuperGamesModel *gameKindSuperModel = [[GameKindSuperGamesModel alloc]initWithDictionary:responseBody error:nil];
            if ([gameKindSuperModel.code intValue] == 0) {
                //往数组新增数据
                for (int i = 0; i < gameKindSuperModel.data.games.count; i++) {
                    GameKindGames *games = (GameKindGames *)gameKindSuperModel.data.games[i];
                    [_gameKindArray addObject:games];
                }
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark -- 懒加载
//UICollectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kNavigationHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentSize = CGSizeMake(kScreen_width, _collectionView.contentSize.height);
        _collectionView.backgroundColor = tableViewBackGroundColor;
        //注册cell
        [_collectionView registerClass:[GameKindCollectionViewCell class] forCellWithReuseIdentifier:GameKindCollectionCell];
    }
    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _gameKindArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = GameKindCollectionCell;
    GameKindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (_gameKindArray.count) {
        GameKindGames *games = (GameKindGames *)_gameKindArray[indexPath.row];
        [cell resetGamesModel:games];
    }
    return cell;
}
//每个格子大小
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat top = 15;
    CGFloat buttom = 5;
    return UIEdgeInsetsMake(top, 3, buttom, 3);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = kScreen_width/3-6;
    CGFloat itemHeight = 130*kScreenFactor+20;

    return CGSizeMake(itemWidth, itemHeight);

}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_gameKindArray.count) {
        GameKindGames *games = (GameKindGames *)_gameKindArray[indexPath.row];
        
        LiveKindViewController *vc = [[LiveKindViewController alloc]init];
        
        vc.liveKind = @"game";
        vc.channelId = games.id;
        vc.title = games.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
