//
//  MineViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MineViewController.h"
#import "OfficialAnnouncementViewController.h"
#import "UIView+YZY.h"
#import "CommonTableData.h"
#import "CommonTableDelegate.h"
@interface MineViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) CommonTableDelegate *delegator;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, self.navigationController.navigationBar.width, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, self.navigationController.navigationBar.width, 0);
    [UIView animateWithDuration:0.35 animations:^{
        
        self.navigationController.navigationBar.frame = CGRectOffset(self.navigationController.navigationBar.frame, -self.navigationController.navigationBar.width, 0);
    } completion:^(BOOL finished) {
        if (finished) {

        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initTableView];
}
#pragma mark -- initData
- (void)initData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MineData" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
    self.data = [CommonTableSection sectionWithData:data];
}
#pragma mark -- 建立view
- (void)initTableView
{
    [self.view addSubview:self.tableView];
    
}
#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kTabbarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = tableViewBackGroundColor;
        __weak typeof(self) weakSelf = self;
        self.delegator = [[CommonTableDelegate alloc]initWithTableData:^NSArray *{
            return weakSelf.data;
        }];
        _tableView.dataSource = self.delegator;
        _tableView.delegate = self.delegator;
    }
    return _tableView;
}

#pragma mark - Action
- (void)dailyTask//每日任务
{
    
}

- (void)mySubscription//我的订阅
{
    
}
- (void)startedRemind//开播提醒
{
    
}
- (void)watchHistory//观看历史
{
    
}
- (void)directMessages//私信
{
    
}
- (void)officialAnnouncement//官方公告
{
    OfficialAnnouncementViewController *vc = [[OfficialAnnouncementViewController alloc]initWithNibName:nil bundle:nil];
    vc.title = @"官方公告";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
