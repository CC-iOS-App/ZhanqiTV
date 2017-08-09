//
//  HomeViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
#define HomeCollectionGameCell @"homeGameCell"
#define HomeCollectionCell @"homeCell"
#define HomeCollectionTalentShowCell @"homeCollectionTalentShowCell"
#define HomeCollectionHotCell @"homeHotCell"
#define HomeCollectionHeder @"homeHeader"
#define HomeSectionHeader @"HomeSectionHeader"
#define HomeCollectionFooter @"homeFooter"
#import "HomeViewController.h"
#import "ZhanqiTVHeader.pch"
@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    NSUInteger _needWaitTime;   //时间
    /**
    *  网络请求回来的数据
    *
    *  @param  _homeSuperListModel          首页推荐直播
    *  @param  _recommendSuperGameModel     推荐游戏类型
    *  @param  _shufflingSuperRoomModel     顶部轮播
    */
    HomeSuperListModel *_homeSuperListModel;
    ShufflingSuperRoomModel *_shufflingSuperRoomModel;
    RecommendSuperGameModel *_recommendSuperGameModel;
    NSMutableArray *_hotLiveArray;
    BOOL  isHotBatch;//yes为点击热门直播的换一批，no为下拉刷新
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HomeViewController
//战旗tv的3个根视图的nav好像是个view 但是我这里暂时不用view（也可能是自定义的转场动画特效）
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
        [button addTarget:self action:@selector(didSelecButton:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"首页", nil);
    //[self setNav];
    //[self buildView];//建立页面
}
#pragma mark -- 初始化View
- (void)buildView
{
    [self.view addSubview:self.collectionView];
    [self setUpCollectionView];
}
//设置collectionView刷新
- (void)setUpCollectionView
{
    //默认为下拉刷新
    _hotLiveArray = [NSMutableArray array];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getHomeData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
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
#pragma mark -- 获取请求返回的数据
- (void)getHomeData
{
    //如果请求间隔超过默认请求时间，执行网络请求，否则不请求
    if (_needWaitTime >= NetworkRequestInterval) {
        _needWaitTime = 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getBanner];//顶部轮播数据
            [self getRecommendKind];//获取轮播图下面推荐直播类型数据
            [self getOtherRecommend];//获取包括热门直播及以下的直播信息数据
            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                
            });
        });
    }
    else
    {
        //默认延后一段时间结束刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
    }
}
//轮播图数据
- (void)getBanner
{
    NSString *url = @"touch/apps.banner";
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        _shufflingSuperRoomModel = [[ShufflingSuperRoomModel alloc]initWithDictionary:responseBody error:nil];
        if ([_shufflingSuperRoomModel.code intValue] == 0) {
            
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
//直播类型数据
- (void)getRecommendKind
{
    NSString *url = @"static/apps.recommend/game.json";
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        _recommendSuperGameModel = [[RecommendSuperGameModel alloc]initWithDictionary:responseBody error:nil];
        if ([_recommendSuperGameModel.code intValue] == 0) {
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
//其它直播数据
- (void)getOtherRecommend
{
    isHotBatch = NO;//下拉刷新的时候热门直播
    NSString *url = @"static/live.index/recommend-new.json";
    
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        _homeSuperListModel = [[HomeSuperListModel alloc]initWithDictionary:responseBody error:nil];
        if ([_homeSuperListModel.code intValue] == 0) {
            [self.collectionView reloadData];
            
        }
        [self.collectionView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        
    }];
}

//TODO:热门直播刷新
- (void)hotLiveRefrsh
{//比较特别，单独拿出来处理
    isHotBatch = YES;
    NSString *url = @"touch/live.index/hot.json";
    [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseBody];
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        if ([[dict objectForKey:@"code"] intValue] == 0) {
            if (_hotLiveArray.count) {
                [_hotLiveArray removeAllObjects];
            }
            NSArray *comparArray = [[dataDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];//数字大小排序后的数组
            for (int i = 0; i < comparArray.count; i++) {
                HotLiveNumber *model = [[HotLiveNumber alloc]initWithDictionary:[dataDict objectForKey:comparArray[i]] error:nil];
                [_hotLiveArray addObject:model];
            }
            [self.collectionView reloadData];//刷新热门直播section
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 懒加载
//UICollectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册cell
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:HomeCollectionCell];
        [_collectionView registerClass:[HomeGameKindCell class] forCellWithReuseIdentifier:HomeCollectionGameCell];
        [_collectionView registerClass:[HomeHotLiveCell class] forCellWithReuseIdentifier:HomeCollectionHotCell];
        [_collectionView registerClass:[HomeTalentShowCollectionCell class] forCellWithReuseIdentifier:HomeCollectionTalentShowCell];
        //header
        [_collectionView registerClass:[HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeCollectionHeder];
        [_collectionView registerClass:[HomeSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader];
        //footer
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomeCollectionFooter];
    }
    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _homeSuperListModel.data.count+1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section > 0 && section != 1) {
        NSUInteger count = ((HomeListModel *)_homeSuperListModel.data[section-1]).lists.count;
        if (count >= 4) {
            return 4;
        }
        else
        {
            return count;
        }
    }
    else
    {
        return 1;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = HomeCollectionGameCell;
        HomeGameKindCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.viewController = self;
        if (_recommendSuperGameModel.data) {
            [cell resetArray:_recommendSuperGameModel];
        }
    
        return cell;
    }
    else
    {
        if (_homeSuperListModel.data) {
            HomeListModel *model = (HomeListModel *)_homeSuperListModel.data[indexPath.section-1];
            if (indexPath.section == 1)
            {
                static NSString *cellIdentifier = HomeCollectionHotCell;
                HomeHotLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                cell.viewController = self;
                if (isHotBatch == YES) {
                    [cell resetArray:_hotLiveArray];
                }
                else
                {
                    [cell resetModel:model];
                }
                return cell;
            }
            else
            {
                if ([model.title isEqualToString:@"达人美拍"]) {
                    static NSString *cellIdentifier = HomeCollectionTalentShowCell;
                    HomeTalentShowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell resetModel:model.lists[indexPath.row]];
                    return cell;
                }
                else
                {
                    static NSString *cellIdentifier = HomeCollectionCell;
                    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell resetModel:model.lists[indexPath.row]];
                    return cell;
                }
            }
        }
        return nil;
    }
}
//每个格子大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat itemWidth = kScreen_width/2;
    CGFloat itemHeight = 110*kScreenFactor;
    if (indexPath.section == 0) {
        return CGSizeMake(kScreen_width, 85*kScreenFactor+5);
    }
    else if (indexPath.section == 1)
    {
        return CGSizeMake(kScreen_width, 95*kScreenFactor+15);
    }
    else
    {
        HomeListModel *model = (HomeListModel *)_homeSuperListModel.data[indexPath.section-1];
        if ([model.title isEqualToString:@"达人美拍"]) {
            return CGSizeMake(itemWidth, 146*kScreenFactor+5);
        }
        return CGSizeMake(itemWidth, itemHeight);
    }
}
//header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kScreen_width, 115*kScreenFactor);
    }
    return CGSizeMake(kScreen_width, 50*kScreenFactor);
}
//footer大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0 && section == 1) {
        return CGSizeMake(kScreen_width, 15);
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            HomeHeaderView *shufflingHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeCollectionHeder forIndexPath:indexPath];
            
            if (_shufflingSuperRoomModel) {
                [shufflingHeader resetModel:_shufflingSuperRoomModel];
            }
            reusableView = shufflingHeader;
        }
        else
        {
            HomeSectionView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeSectionHeader forIndexPath:indexPath];
            
            if (_homeSuperListModel) {
                [sectionView resetTitle:((HomeListModel *)_homeSuperListModel.data[indexPath.section-1])];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionViewAction:)];
                sectionView.headerView.tag = indexPath.section - 1;
                [sectionView.headerView addGestureRecognizer:tap];
            }
            reusableView = sectionView;
        }
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        if (indexPath.section == 0 && indexPath.section == 1) {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomeCollectionFooter forIndexPath:indexPath];
            footer.backgroundColor = tableViewBackGroundColor;
            reusableView = footer;
        }
    }
    return reusableView;
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >1) {
        LiveDetailViewController *vc = [[LiveDetailViewController alloc]init];
        HomeListModel *model = (HomeListModel *)_homeSuperListModel.data[indexPath.section-1];
        List *list = (List *)model.lists[indexPath.row];
        vc.videoId = list.videoId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- 换一批以及更多触发方法
- (void)sectionViewAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 0) {
        [self hotLiveRefrsh];//热门直播换一批
    }
    else
    {
        HomeListModel *listModel = (HomeListModel *)_homeSuperListModel.data[tap.view.tag];
        if ([listModel.title isEqualToString:@"达人美拍"]) {
            TalentShowViewController *vc = [[TalentShowViewController alloc]init];
            //判断有没channelid， 没有 用gameid
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]\"\""];
            NSString *channelId = [NSString string];
            channelId = [listModel.channelIds stringByTrimmingCharactersInSet:characterSet];
            vc.liveKind = @"channel";
            if ([channelId isEqualToString:@"null"]) {
                channelId = [listModel.gameIds stringByTrimmingCharactersInSet:characterSet];
                vc.liveKind = @"game";
            }
            vc.channelId = channelId;
            vc.title = listModel.title;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LiveKindViewController *vc = [[LiveKindViewController alloc]init];
            //判断有没channelid， 没有 用gameid
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]\"\""];
            NSString *channelId = [NSString string];
            channelId = [listModel.channelIds stringByTrimmingCharactersInSet:characterSet];
            vc.liveKind = @"channel";
            if ([channelId isEqualToString:@"null"]) {
                channelId = [listModel.gameIds stringByTrimmingCharactersInSet:characterSet];
                vc.liveKind = @"game";
            }
            vc.channelId = channelId;
            vc.title = listModel.title;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -- 导航栏方法
- (void)didSelecButton:(UIButton *)button
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
@end
