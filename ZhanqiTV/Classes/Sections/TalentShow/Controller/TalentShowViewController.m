//
//  TalentShowViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
//static const NSUInteger PAGE_SIZE = 20;  //一页显示数据数量
#define PAGE_SIZE 20
#define TalentShowCell @"TalentShowCell"

#import "TalentShowCollectionCell.h"
#import "TalentShowViewController.h"
#import "TalentShowDetailViewController.h"
@interface TalentShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    NSUInteger _needWaitTime;   //时间
    
    NSMutableArray *_talentShowArray;//直播数据数组
    
    NSUInteger currenPage;//当前页
    NSUInteger totalNumber;//总页数
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TalentShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];//建立页面
}
- (void)initCollectionView
{
    _talentShowArray = [[NSMutableArray alloc]init];
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
#pragma mark -- 下拉刷新
- (void)dropDownRefresh
{
    //如果请求间隔超过默认请求时间，执行网络请求，否则不请求
    if (_needWaitTime >= NetworkRequestInterval) {
        _needWaitTime = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getTalenShowData];//请求刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                
            });
        });
    }
    else
    {
        //默认延后一段时间结束刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            //结束刷新
            if (_talentShowArray.count > PAGE_SIZE) {
                NSMutableArray *newArray = [[NSMutableArray alloc]init];
                for (int a = 0; a < _talentShowArray.count; a++) {
                    [newArray addObject:[_talentShowArray objectAtIndex:a]];
                }
                [_talentShowArray removeAllObjects];
                for (int i = 0; i < PAGE_SIZE ; i++) {
                    
                    [_talentShowArray addObject:[newArray objectAtIndex:i]];
                }
                [self.collectionView reloadData];
            }
            [self.collectionView.mj_header endRefreshing];
        });
    }
}
#pragma mark -- 获取请求返回的数据
- (void)getTalenShowData
{
    NSString *url = [NSString stringWithFormat:@"static/%@.lives/%@/20-%lu.json",self.liveKind,self.channelId,currenPage];
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        LiveKindSuperRoomModel *liveKindSuperRoomModel = [[LiveKindSuperRoomModel alloc]initWithDictionary:responseBody error:nil];
        if ([liveKindSuperRoomModel.code intValue] == 0) {
            totalNumber = [liveKindSuperRoomModel.data.cnt integerValue]/PAGE_SIZE+1;
            //往数组新增数据
            for (int i = 0; i < liveKindSuperRoomModel.data.rooms.count; i++) {
                LiveKindRooms *rooms = (LiveKindRooms *)liveKindSuperRoomModel.data.rooms[i];
                [_talentShowArray addObject:rooms];
            }
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
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
        NSString *url = [NSString stringWithFormat:@"static/%@.lives/%@/20-%lu.json",self.liveKind,self.channelId,currenPage];
        [self.collectionView.mj_footer beginRefreshing];
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            
            LiveKindSuperRoomModel *liveKindSuperRoomModel = [[LiveKindSuperRoomModel alloc]initWithDictionary:responseBody error:nil];
            if ([liveKindSuperRoomModel.code intValue] == 0) {
                //往数组新增数据
                for (int i = 0; i < liveKindSuperRoomModel.data.rooms.count; i++) {
                    LiveKindRooms *rooms = (LiveKindRooms *)liveKindSuperRoomModel.data.rooms[i];
                    [_talentShowArray addObject:rooms];
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
        layout.minimumInteritemSpacing = 3;
        layout.minimumLineSpacing = 2;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kNavigationHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentSize = CGSizeMake(kScreen_width, _collectionView.contentSize.height);
        _collectionView.backgroundColor = tableViewBackGroundColor;
        //注册cell
        [_collectionView registerClass:[TalentShowCollectionCell class] forCellWithReuseIdentifier:TalentShowCell];
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
    return _talentShowArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = TalentShowCell;
    TalentShowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (_talentShowArray.count) {
        LiveKindRooms *rooms = (LiveKindRooms *)_talentShowArray[indexPath.row];
        [cell resetRoomsModel:rooms];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = kScreen_width/2-2;
    CGFloat itemHeight = 160*kScreenFactor;
    
    return CGSizeMake(itemWidth, itemHeight);
    
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalentShowDetailViewController *vc = [[TalentShowDetailViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
