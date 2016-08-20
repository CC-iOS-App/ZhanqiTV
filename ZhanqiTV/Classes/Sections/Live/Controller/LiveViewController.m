//
//  LiveViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
//static const NSUInteger PAGE_SIZE = 20;  //一页显示数据数量
#define PAGE_SIZE 20
#define LiveCollectionViewCell @"liveCell"

#import "LiveViewController.h"
#import "LiveRoomsModel.h"
#import "LiveCollectionCell.h"

#import "UIView+YZY.h"
@interface LiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    NSUInteger _needWaitTime;   //时间
    
     NSMutableArray *_liveArray;//直播数据数组
    
    NSUInteger currenPage;//当前页
    NSUInteger totalNumber;//总页数
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation LiveViewController
//导航栏设置
- (void)setNav{
    //设置左边图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_zhanqi"]];
    imageView.frame = CGRectMake(10, 25, 60, 29);
    imageView.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //设置右边按钮
    CGFloat buttonWidth = 24.0f;
    
    NSArray *buttonImageArray = [NSArray arrayWithObjects:@"nav_search",@"nav_history",@"nav_liveKind", nil];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth*3+20, 44)];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(10+buttonWidth), 8, buttonWidth, buttonWidth);
        [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
        
        [rightView addSubview:button];
    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //页面将要出现时，隐藏导航栏
    [self.navigationController.navigationBar setBarTintColor:navigationBarColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self initCollectionView];
}
#pragma mark -- 初始化View
- (void)initCollectionView
{
    _liveArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.collectionView];
    [self setUpCollectionView];
}
//设置collectionView刷新
- (void)setUpCollectionView
{
    currenPage = 1;//默认当前页为1；
    //默认为下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
    //添加上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData)];
    _needWaitTime = NetworkRequestInterval;
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
#pragma mark -- 下拉刷新
- (void)dropDownRefresh
{
    //如果请求间隔超过默认请求时间，执行网络请求，否则不请求
    if (_needWaitTime >= NetworkRequestInterval) {
        _needWaitTime = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getLiveData];//请求刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                
            });
        });
    }
    else
    {
        //默认延后一段时间结束刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            //结束刷新
            if (_liveArray.count > PAGE_SIZE) {
                NSMutableArray *newArray = [[NSMutableArray alloc]init];
                for (int a = 0; a < _liveArray.count; a++) {
                    [newArray addObject:[_liveArray objectAtIndex:a]];
                }
                [_liveArray removeAllObjects];
                for (int i = 0; i < PAGE_SIZE ; i++) {
                    
                    [_liveArray addObject:[newArray objectAtIndex:i]];
                }
                [self.collectionView reloadData];
            }
            [self.collectionView.mj_header endRefreshing];
        });
    }
}
//获取直播数据
- (void)getLiveData
{
    NSString *url = [NSString stringWithFormat:@"static/live.hots/20-%ld.json",currenPage];
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        LiveSuperRoomsModel *liveSuperRoomModel = [[LiveSuperRoomsModel alloc]initWithDictionary:responseBody error:nil];
        if ([liveSuperRoomModel.code intValue] == 0) {
            totalNumber = [liveSuperRoomModel.data.cnt integerValue]/PAGE_SIZE+1;
            //往数组新增数据
            for (int i = 0; i < liveSuperRoomModel.data.rooms.count; i++) {
                LiveRooms *rooms = (LiveRooms *)liveSuperRoomModel.data.rooms[i];
                [_liveArray addObject:rooms];
            }
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        }
        else
        {
            [self.collectionView.mj_header endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}
//上拉加载
- (void)upRefreshData
{
    if (currenPage < totalNumber) {
        currenPage ++;
        NSString *url = [NSString stringWithFormat:@"static/live.hots/20-%ld.json",currenPage];
        [self.collectionView.mj_footer beginRefreshing];
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            
            LiveSuperRoomsModel *liveSuperRoomModel = [[LiveSuperRoomsModel alloc]initWithDictionary:responseBody error:nil];
            if ([liveSuperRoomModel.code intValue] == 0) {
                //往数组新增数据
                for (int i = 0; i < liveSuperRoomModel.data.rooms.count; i++) {
                    LiveRooms *rooms = (LiveRooms *)liveSuperRoomModel.data.rooms[i];
                    [_liveArray addObject:rooms];
                }
                
                [self.collectionView reloadData];
            }
            [self.collectionView.mj_footer endRefreshing];
        } failureBlock:^(NSError *error) {
            [self.collectionView.mj_footer endRefreshing];
        }];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark -- 懒加载

- (NSInteger)numberOfItems//一行几个
{
    return 2;
}
- (CGFloat)itemWidth//每个cell宽度
{
    return (NSInteger)((self.view.width - (self.itemSpacing * (self.numberOfItems + 1))) / self.numberOfItems);
}
- (CGFloat)itemHeight//每个cell高度
{
    return 110*kScreenFactor;
}
- (CGFloat)itemSpacing//每行间距
{
    return 8.f;
}
//UICollectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.minimumInteritemSpacing = self.itemSpacing;
        CGFloat padding = self.itemSpacing;
        layout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(padding*2, padding, 0, padding);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = tableViewBackGroundColor;
        //注册cell
        [_collectionView registerClass:[LiveCollectionCell class] forCellWithReuseIdentifier:LiveCollectionViewCell];
    }
    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _liveArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = LiveCollectionViewCell;
    LiveCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (_liveArray.count) {
        LiveRooms *rooms = (LiveRooms *)_liveArray[indexPath.row];
        [cell resetRoomsModel:rooms];
    }
    return cell;
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveDetailViewController *vc = [[LiveDetailViewController alloc]init];
    LiveRooms *rooms = (LiveRooms *)_liveArray[indexPath.row];
    vc.videoId = rooms.videoId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 导航栏方法
- (void)didSelectButton:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            NSLog(@"搜索");
            break;
        case 1:
            NSLog(@"历史记录 ");
            break;
        case 2:
        {
            //直播类别选择
            GameKindViewController *vc = [[GameKindViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
