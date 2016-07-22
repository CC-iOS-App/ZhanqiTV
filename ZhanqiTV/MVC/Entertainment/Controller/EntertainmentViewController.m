//
//  EntertainmentViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
static const NSUInteger PAGE_SIZE = 20;  //一页显示数据数量
#define EntertainmentTopCollectionCell @"entertainmentTopCollectionCell"
#define EntertainmentCollectionCell @"entertainmentCollectionCell"
#define EntertainmentCollectionTalentShowCell @"EntertainmentCollectionTalentShowCell"
#define EntertainmentCollectionSectionCell @"entertainmentCollectionSectionCell"
#define EntertainmentCollectionFooter @"entertainmentCollectionFooter"

#import "EntertainmentTopCell.h"
#import "EntertainmentCell.h"
#import "EntertainmentTalentShowCell.h"
#import "EntertainmentSectionCell.h"
#import "EntertainmentViewController.h"
#import "EntertainmentApplyLiveView.h"
@interface EntertainmentViewController ()<HomeNavDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    NSUInteger _needWaitTime;   //时间
    
    NSMutableArray *_otherArray;//热门直播下面开始一直到百变主播之前数组
    NSMutableArray *_changeHostArray;//百变主播数据数组
    EntertainmentHotSuperModel *_hotSuperModel;//热门直播model
    
    NSUInteger currenPage;//当前页
    NSUInteger totalNumber;//总页数
}
@property (nonatomic, strong) HomeNavView *navView;//顶部导航栏
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) EntertainmentApplyLiveView *applyLiveView;//申请直播
@end

@implementation EntertainmentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //页面将要出现时，隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
}
#pragma mark -- 初始化View
- (void)initCollectionView
{
    _otherArray = [[NSMutableArray alloc]init];
    _changeHostArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collectionView];
    [self mineLiveButton];
    [self.view addSubview:self.applyLiveView];
    [self setUpCollectionView];
}
//自己直播按钮
- (void)mineLiveButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreen_width-70, kScreen_height-kTabbarHeight-25-55, 55, 55);
    [button addTarget:self action:@selector(yourLive:)   forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"Entertainment_live"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button bringSubviewToFront:self.view];
}
//自己直播触发事件
- (void)yourLive:(UIButton *)sender
{
    [self.applyLiveView appearView];
}
//设置collectionView刷新
- (void)setUpCollectionView
{
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
            [self getHotData];//请求热门数据
            [self getOtherLiveData];//热门直播下面开始一直到百变主播之前数据
            [self getChangeData];//请求百变主播数据
            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                
            });
        });
    }
    else
    {
        //默认延后一段时间结束刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            //结束刷新
            currenPage = 1;
            if (_changeHostArray.count > PAGE_SIZE) {
                NSMutableArray *newArray = [[NSMutableArray alloc]init];
                for (int a = 0; a < _changeHostArray.count; a++) {
                    [newArray addObject:[_changeHostArray objectAtIndex:a]];
                }
                [_changeHostArray removeAllObjects];
                for (int i = 0; i < PAGE_SIZE ; i++) {
                    
                    [_changeHostArray addObject:[newArray objectAtIndex:i]];
                }
                [self.collectionView reloadData];
            }
            [self.collectionView.mj_header endRefreshing];
        });
    }
}
//上拉加载百变主播数据
- (void)upRefreshData
{
    if (currenPage < totalNumber) {
        currenPage ++;
        NSString *url = [NSString stringWithFormat:@"static/game.lives/65/20-%ld.json",currenPage];
        [self.collectionView.mj_footer beginRefreshing];
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            
            EntertainmentChangedSuperModel *entertainmentChangedSuperModel = [[EntertainmentChangedSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([entertainmentChangedSuperModel.code intValue] == 0) {
                //往数组新增数据
                for (int i = 0; i < entertainmentChangedSuperModel.data.rooms.count; i++) {
                    EntertainmentChangedRooms *rooms = (EntertainmentChangedRooms *)entertainmentChangedSuperModel.data.rooms[i];
                    [_changeHostArray addObject:rooms];
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
        [self.collectionView.mj_footer endRefreshing];
    }
}
- (void)getHotData//请求热门数据
{
    NSString *url = @"static/live.area/gamer.json";
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        _hotSuperModel = [[EntertainmentHotSuperModel alloc]initWithDictionary:responseBody error:nil];
        if ([_hotSuperModel.code intValue] == 0) {
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)getOtherLiveData//热门直播下面开始一直到百变主播之前数据
{
    NSString *url = @"static/mobile/index.area/gammer-none-all-2.json";
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        EntertainmentOtherSuperModel *_otherSuperModel = [[EntertainmentOtherSuperModel alloc]initWithDictionary:responseBody error:nil];
        if ([_otherSuperModel.code intValue] == 0) {
            for (int i = 0;i < _otherSuperModel.data.count; i++) {
                EntertainmentOtherModel *model = (EntertainmentOtherModel *)_otherSuperModel.data[i];
                if (model.lists.count) {
                    [_otherArray addObject:model];
                }
            }
            [self.collectionView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)getChangeData//请求百变主播数据
{
    currenPage = 1;
    NSString *url = [NSString stringWithFormat:@"static/game.lives/65/20-%ld.json",currenPage];
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        EntertainmentChangedSuperModel *entertainmentChangedSuperModel = [[EntertainmentChangedSuperModel alloc]initWithDictionary:responseBody error:nil];
        if ([entertainmentChangedSuperModel.code intValue] == 0) {
            totalNumber = [entertainmentChangedSuperModel.data.cnt integerValue]/PAGE_SIZE+1;
            //往数组新增数据
            for (int i = 0; i < entertainmentChangedSuperModel.data.rooms.count; i++) {
                EntertainmentChangedRooms *rooms = (EntertainmentChangedRooms *)entertainmentChangedSuperModel.data.rooms[i];
                [_changeHostArray addObject:rooms];
            }
            [self.collectionView reloadData];
        }
        [self.collectionView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark -- 懒加载
- (EntertainmentApplyLiveView *)applyLiveView
{
    if (!_applyLiveView) {
        _applyLiveView = [[EntertainmentApplyLiveView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kTabbarHeight)];
        [_applyLiveView hideView];
    }
    return _applyLiveView;
}
//导航条
- (HomeNavView *)navView
{
    if (!_navView) {
        _navView = [[HomeNavView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kNavigationHeight)];
        _navView.delegate = self;
    }
    return _navView;
}
//UICollectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, kScreen_width, kScreen_height-kNavigationHeight-kTabbarHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentSize = CGSizeMake(kScreen_width, _collectionView.contentSize.height);
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册cell
        [_collectionView registerClass:[EntertainmentCell class] forCellWithReuseIdentifier:EntertainmentCollectionCell];
        [_collectionView registerClass:[EntertainmentTalentShowCell class] forCellWithReuseIdentifier:EntertainmentCollectionTalentShowCell];
        [_collectionView registerClass:[EntertainmentTopCell class] forCellWithReuseIdentifier:EntertainmentTopCollectionCell];
        //header
        [_collectionView registerClass:[EntertainmentSectionCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntertainmentCollectionSectionCell];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defalutHeader"];
        //footer
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:EntertainmentCollectionFooter];
        
    }
    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _otherArray.count+2+1;//2为顶部与热门直播，1为百变主播
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        NSUInteger count = _hotSuperModel.data.hotRoom.rooms.count;
        return count >= 4 ? 4:count;
    }
    else if (section > 1)
    {
        if (section < _otherArray.count+2) {
            NSUInteger count = ((EntertainmentOtherModel *)_otherArray[section -2]).lists.count;
            return count >= 4 ? 4:count;
        }
        else
        {
            return _changeHostArray.count;
        }
        
    }
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = EntertainmentTopCollectionCell;
        EntertainmentTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell resetModel:_hotSuperModel.data];
        return cell;
    }
    else
    {
        if (indexPath.section == 1)
        {
            static NSString *cellIdentifier = EntertainmentCollectionCell;
            
            EntertainmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell resetHotModel:(EntertainmentHotRoomRooms *)_hotSuperModel.data.hotRoom.rooms[indexPath.row]];
            return cell;
        }
        else if (indexPath.section > 1)
        {
            if (indexPath.section < _otherArray.count+2) {
                EntertainmentOtherModel *model = (EntertainmentOtherModel *)_otherArray[indexPath.section - 2];
                EntertainmentOtherList *list = (EntertainmentOtherList *)model.lists[indexPath.row];
                if ([model.title isEqualToString:@"达人美拍"]) {
                    static NSString *cellIdentifier = EntertainmentCollectionTalentShowCell;
                    EntertainmentTalentShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell resetModel:list];
                    return cell;
                }
                else
                {
                    static NSString *cellIdentifier = EntertainmentCollectionCell;
                    
                    EntertainmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell resetOtherModel:list];
                    return cell;
                }
            }
            else
            {
                static NSString *cellIdentifier = EntertainmentCollectionCell;
                
                EntertainmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                
                [cell resetChangeModel:(EntertainmentChangedRooms *)_changeHostArray[indexPath.row]];
                return cell;
            }
        }
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreen_width, 10);
    }
    return CGSizeMake(kScreen_width, 50*kScreenFactor);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreen_width, 10);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = kScreen_width/2;
    CGFloat itemHeight = 110*kScreenFactor;
    
    if (indexPath.section == 0) {
        return CGSizeMake(kScreen_width, 97*kScreenFactor);
    }
    else
    {
        if (indexPath.section > 1) {
            if (indexPath.section < _otherArray.count+2) {
                EntertainmentOtherModel *model = (EntertainmentOtherModel *)_otherArray[indexPath.section - 2];
                if ([model.title isEqualToString:@"达人美拍"]) {
                    return CGSizeMake(itemWidth, 146*kScreenFactor+5);
                }
            }
        }
    }
    return CGSizeMake(itemWidth, itemHeight);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;

        if (kind == UICollectionElementKindSectionHeader) {
            if (indexPath.section == 0) {
                UICollectionReusableView *defalut = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defalutHeader" forIndexPath:indexPath];
                defalut.backgroundColor = tableViewBackGroundColor;
                reusableView = defalut;
            }
            else
            {
                EntertainmentSectionCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EntertainmentCollectionSectionCell forIndexPath:indexPath];
                
                if (indexPath.section == 1) {
                    if (_hotSuperModel) {
                        [headerView resetHotTitle:@"热门直播"];
                    }
                    
                }
                else if (indexPath.section > 1)
                {
                    if (indexPath.section < _otherArray.count+2)
                    {
                        if (_otherArray.count) {
                            [headerView resetOtherTitle:(EntertainmentOtherModel *)_otherArray[indexPath.section-2]];
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionViewAction:)];
                            headerView.headerView.tag = indexPath.section - 2;
                            [headerView.headerView addGestureRecognizer:tap];
                        }
                    }
                    else
                    {
                        if (_changeHostArray.count) {
                            [headerView resetChangeHostTitle:@"百变主播"];
                        }
                    }
                }
                reusableView = headerView;
            }
            
        }
        else if (kind == UICollectionElementKindSectionFooter)
        {
            if (indexPath.section == 0) {
                UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:EntertainmentCollectionFooter forIndexPath:indexPath];
                footer.backgroundColor = tableViewBackGroundColor;
                reusableView = footer;
            }
        }
    return reusableView;
}
#pragma mark -- UICollectionViewDelegate


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    LiveDetailViewController *vc = [[LiveDetailViewController alloc]init];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark -- HomeNavDelegate(导航栏代理方法)
- (void)didSelectButton:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"搜索");
    }
    else if (index == 1)
    {
        NSLog(@"历史记录 ");
    }
    else if (index == 2)
    {
        //直播类别选择
        GameKindViewController *vc = [[GameKindViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- 达人美拍
- (void)sectionViewAction:(UITapGestureRecognizer *)tap
{
    EntertainmentOtherModel *model = (EntertainmentOtherModel *)_otherArray[tap.view.tag];
    if ([model.title isEqualToString:@"达人美拍"]) {
        TalentShowViewController *vc = [[TalentShowViewController alloc]init];
        //判断有没channelid， 没有 用gameid
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]\"\""];
        NSString *channelId = [NSString string];
        channelId = [model.channelIds stringByTrimmingCharactersInSet:characterSet];
        vc.liveKind = @"channel";
        if ([channelId isEqualToString:@"null"]) {
            channelId = [model.gameIds stringByTrimmingCharactersInSet:characterSet];
            vc.liveKind = @"game";
        }
        vc.channelId = channelId;
        vc.title = model.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LiveKindViewController *vc = [[LiveKindViewController alloc]init];
        //判断有没channelid， 没有 用gameid
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]\"\""];
        NSString *channelId = [NSString string];
        channelId = [model.channelIds stringByTrimmingCharactersInSet:characterSet];
        vc.liveKind = @"channel";
        if ([channelId isEqualToString:@"null"]) {
            channelId = [model.gameIds stringByTrimmingCharactersInSet:characterSet];
            vc.liveKind = @"game";
        }
        vc.channelId = channelId;
        vc.title = model.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
