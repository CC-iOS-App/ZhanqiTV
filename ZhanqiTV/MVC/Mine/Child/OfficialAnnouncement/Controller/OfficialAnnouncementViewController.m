//
//  OfficialAnnouncementViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
static const NSUInteger PAGE_SIZE = 20;
#import "OfficialAnnouncementViewController.h"
#import "OfficialAnnouncementView.h"//自定义头部view
#import "OfficialAnnoucementTableView.h"//自定义tableview
@interface OfficialAnnouncementViewController ()<OfficialAnnouncementViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_allArray;//全部
    NSMutableArray *_announcementArray;//公告
    NSMutableArray *_activityArray;//活动
    NSMutableArray *_newsArray;//新闻
    NSMutableArray *_interviewArray;//访谈
}
@property (nonatomic, strong) OfficialAnnouncementView *topView;//顶部全部公告等自定义view
@property (nonatomic, strong) UIScrollView *scrollView;//存放tableView
@end

@implementation OfficialAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    [self initData];
}
//TODO:建立view
- (void)initView
{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrollView];
}
//TODO:获取数据
- (void)initData//初始化数组
{
    _allArray = [[NSMutableArray alloc]init];
    _announcementArray = [[NSMutableArray alloc]init];
    _activityArray = [[NSMutableArray alloc]init];
    _newsArray = [[NSMutableArray alloc]init];
    _interviewArray = [[NSMutableArray alloc]init];
    [self getInternetData];
}
//网络请求数据
- (void)getInternetData
{
    [self getAllData:YES];//全部
    [self getNoticeData:YES];//公告
    [self getActiveData:YES];//活动
    [self getNewsData:YES];//新闻
    [self getInterViewData:YES];//访谈
}
//全部
- (void)getAllData:(BOOL)isDownRefresh
{
    OfficialAnnoucementTableView *tableView = [self tableView:100];
    
    if (tableView) {
        if (isDownRefresh == YES) {
            tableView.currenPage = 1;
        }
        NSString *url = [NSString stringWithFormat:@"static/news.lists/all/20-%lu.json",tableView.currenPage];
        
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            OfficialAnnouncementSuperModel *officialAnnouncementSuperModel = [[OfficialAnnouncementSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([officialAnnouncementSuperModel.code intValue] == 0) {//成功
                NSUInteger totalLiveNumber = [officialAnnouncementSuperModel.data.cnt integerValue];
                tableView.pageNumber = ((int)(totalLiveNumber/PAGE_SIZE))+1;
                for (int i = 0; i < officialAnnouncementSuperModel.data.news.count; i++) {
                    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)officialAnnouncementSuperModel.data.news[i];
                    [_allArray addObject:model];
                }
                if (isDownRefresh == NO) {
                    [tableView.mj_footer endRefreshing];
                }
                [tableView reloadData];
            }
            
        } failureBlock:^(NSError *error) {
            if (isDownRefresh == NO) {
                [tableView.mj_footer endRefreshing];
            }
        }];
    }
}
//公告
- (void)getNoticeData:(BOOL)isDownRefresh
{
    OfficialAnnoucementTableView *tableView = [self tableView:101];
    
    if (tableView) {
        if (isDownRefresh == YES) {
            tableView.currenPage = 1;
        }
        NSString *url = [NSString stringWithFormat:@"static/news.lists/notice/20-%lu.json",tableView.currenPage];
        
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            OfficialAnnouncementSuperModel *officialAnnouncementSuperModel = [[OfficialAnnouncementSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([officialAnnouncementSuperModel.code intValue] == 0) {//成功
                 NSUInteger totalLiveNumber = [officialAnnouncementSuperModel.data.cnt integerValue];
                tableView.pageNumber = ((int)(totalLiveNumber/PAGE_SIZE))+1;
                for (int i = 0; i < officialAnnouncementSuperModel.data.news.count; i++) {
                    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)officialAnnouncementSuperModel.data.news[i];
                    [_announcementArray addObject:model];
                }
                if (isDownRefresh == NO) {
                    [tableView.mj_footer endRefreshing];
                }
                [tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
            if (isDownRefresh == NO) {
                [tableView.mj_footer endRefreshing];
            }
        }];
    }
}
//活动
- (void)getActiveData:(BOOL)isDownRefresh
{
    OfficialAnnoucementTableView *tableView = [self tableView:102];
    
    if (tableView) {
        if (isDownRefresh == YES) {
            tableView.currenPage = 1;
        }
        NSString *url = [NSString stringWithFormat:@"static/news.lists/active/20-%lu.json",tableView.currenPage];
        
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            OfficialAnnouncementSuperModel *officialAnnouncementSuperModel = [[OfficialAnnouncementSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([officialAnnouncementSuperModel.code intValue] == 0) {//成功
                NSUInteger totalLiveNumber = [officialAnnouncementSuperModel.data.cnt integerValue];
                tableView.pageNumber = ((int)(totalLiveNumber/PAGE_SIZE))+1;
                for (int i = 0; i < officialAnnouncementSuperModel.data.news.count; i++) {
                    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)officialAnnouncementSuperModel.data.news[i];
                    [_activityArray addObject:model];
                }
                if (isDownRefresh == NO) {
                    [tableView.mj_footer endRefreshing];
                }
                [tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
            if (isDownRefresh == NO) {
                [tableView.mj_footer endRefreshing];
            }
        }];
    }
}
//新闻
- (void)getNewsData:(BOOL)isDownRefresh
{
    OfficialAnnoucementTableView *tableView = [self tableView:103];
    
    if (tableView) {
        if (isDownRefresh == YES) {
            tableView.currenPage = 1;
        }
        NSString *url = [NSString stringWithFormat:@"static/news.lists/news/20-%lu.json",tableView.currenPage];
        
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            OfficialAnnouncementSuperModel *officialAnnouncementSuperModel = [[OfficialAnnouncementSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([officialAnnouncementSuperModel.code intValue] == 0) {//成功
                NSUInteger totalLiveNumber = [officialAnnouncementSuperModel.data.cnt integerValue];
                tableView.pageNumber = ((int)(totalLiveNumber/PAGE_SIZE))+1;
                for (int i = 0; i < officialAnnouncementSuperModel.data.news.count; i++) {
                    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)officialAnnouncementSuperModel.data.news[i];
                    [_newsArray addObject:model];
                }
                if (isDownRefresh == NO) {
                    [tableView.mj_footer endRefreshing];
                }
                [tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
            if (isDownRefresh == NO) {
                [tableView.mj_footer endRefreshing];
            }
        }];
    }
}
//访谈
- (void)getInterViewData:(BOOL)isDownRefresh
{
    OfficialAnnoucementTableView *tableView = [self tableView:104];
    
    if (tableView) {
        if (isDownRefresh == YES) {
            tableView.currenPage = 1;
        }
        NSString *url = [NSString stringWithFormat:@"static/news.lists/interview/20-%lu.json",tableView.currenPage];
        
        [NetworkSingleton httpGET:url headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
            OfficialAnnouncementSuperModel *officialAnnouncementSuperModel = [[OfficialAnnouncementSuperModel alloc]initWithDictionary:responseBody error:nil];
            if ([officialAnnouncementSuperModel.code intValue] == 0) {//成功
                NSUInteger totalLiveNumber = [officialAnnouncementSuperModel.data.cnt integerValue];
                tableView.pageNumber = ((int)(totalLiveNumber/PAGE_SIZE))+1;
                for (int i = 0; i < officialAnnouncementSuperModel.data.news.count; i++) {
                    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)officialAnnouncementSuperModel.data.news[i];
                    [_interviewArray addObject:model];
                }
                if (isDownRefresh == NO) {
                    [tableView.mj_footer endRefreshing];
                }
                [tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
            if (isDownRefresh == NO) {
                [tableView.mj_footer endRefreshing];
            }
        }];
    }
}
#pragma mark -- 懒加载
- (OfficialAnnouncementView *)topView
{
    if (!_topView) {
        _topView = [[OfficialAnnouncementView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 30) withArray:@[@"全部",@"公告",@"活动",@"新闻",@"访谈"]];
        _topView.delegate = self;
    }
    return _topView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), kScreen_width, kScreen_height-viewHeight(self.topView)-kNavigationHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(5*kScreen_width, viewHeight(_scrollView));
        //创建5个tableview存储信息数据
        for (int i = 0; i < 5; i++) {
            OfficialAnnoucementTableView *tableView = [[OfficialAnnoucementTableView alloc]initWithFrame:CGRectMake(i*viewWidth(_scrollView), 0, viewWidth(_scrollView), viewHeight(_scrollView)) style:UITableViewStylePlain];
            
            tableView.tag = 100+i;
            tableView.tableFooterView = [[UIView alloc]init];
            tableView.dataSource = self;
            tableView.delegate = self;
            
            //添加上拉加载
            tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefreshData:)];
            [_scrollView addSubview:tableView];
        }
    }
    return _scrollView;
}
//TODO:上拉加载
- (void)upRefreshData:(OfficialAnnoucementTableView *)tableView
{
   
//    tableView.currenPage += 1;
//    if (tableView.pageNumber == tableView.currenPage) {
//        [tableView.mj_footer endRefreshingWithNoMoreData];
//        return;
//    }
//    switch (tableView.tag) {
//        case 100://全部
//            
//            [self getAllData:NO];
//            break;
//        case 101://公告
//            [self getNoticeData:NO];
//            break;
//        case 102://活动
//            [self getActiveData:NO];
//            break;
//        case 103://新闻
//            [self getNewsData:NO];
//            break;
//        case 104://访谈
//            [self getInterViewData:NO];
//            break;
//        default:
//            break;
//    }
}
//上拉加载全部
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 100://全部
            return _allArray.count;
            break;
        case 101://公告
            return _announcementArray.count;
            break;
        case 102://活动
            return _activityArray.count;
            break;
        case 103://新闻
            return _newsArray.count;
            break;
        case 104://访谈
            return _interviewArray.count;
            break;
        default:
            break;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    NSArray *dataArray = nil;
    switch (tableView.tag) {
        case 100://全部
            dataArray = [NSArray arrayWithArray:_allArray];
            break;
        case 101://公告
            dataArray = [NSArray arrayWithArray:_announcementArray];
            break;
        case 102://活动
            dataArray = [NSArray arrayWithArray:_activityArray];
            break;
        case 103://新闻
            dataArray = [NSArray arrayWithArray:_newsArray];
            break;
        case 104://访谈
            dataArray = [NSArray arrayWithArray:_interviewArray];
            break;
        default:
            break;
    }
    OfficialAnnouncementNewsModel *model = (OfficialAnnouncementNewsModel *)dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    if ([model.tag isEqualToString:@"hot"]) {
        cell.imageView.image = [UIImage imageNamed:@"Mine_AnnouncementHot"];
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 100://全部
         
            break;
        case 101://公告
            
            break;
        case 102://活动
           
            break;
        case 103://新闻
            
            break;
        case 104://访谈
            
            break;
        default:
            break;
    }
}
#pragma mark -- OfficialAnnouncementViewDelegate
//点击滑动scrollview
- (void)didSelectAnnouncementButton:(NSUInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(index*kScreen_width, self.scrollView.contentOffset.y)];
}
//TODO:根据tag返回一个tableview
- (OfficialAnnoucementTableView *)tableView:(NSInteger)interger
{
    OfficialAnnoucementTableView *returnTableView = nil;
    
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[OfficialAnnoucementTableView class]]) {
            OfficialAnnoucementTableView *tableView = (OfficialAnnoucementTableView *)subView;
            if (tableView.tag == interger) {
                returnTableView = tableView;
            }
        }
    }
    return returnTableView;
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动视图停止滑动后，更新所选择的按钮
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    if (x > 0) {
        NSInteger page = (x + scrollViewW/2)/scrollViewW;
        [self.topView didSelectedButton:page];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
