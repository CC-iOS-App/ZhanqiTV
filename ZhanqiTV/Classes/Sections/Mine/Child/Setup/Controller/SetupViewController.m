//
//  SetupViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "SetupViewController.h"
#import "BarrageSetupViewController.h"
#import "CommonTableDelegate.h"
#import "CommonTableData.h"
@interface SetupViewController ()<DecodingWayDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DecodingWayView *decodingWayView;
@property (nonatomic, strong) CommonTableDelegate *delegator;
@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.decodingWayString = @"软解";
    [self setNavBarItem];
    [self initData];
    [self initTableView];
}
//导航栏设置
- (void)setNavBarItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton addTarget:self action:@selector(returnLastController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
- (void)returnLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
//初始化数据
- (void)initData
{
    NSArray *data = @[
                        @{
                            HeaderTitle : @"",
                            RowContent  : @[
                                            @{
                                                Title : @"弹幕设置",
                                                ShowAccessory : @(YES),
                                                CellAction : @"barrageSetup"
                                             },
                                            @{
                                                Title : @"清除系统缓存"
                                             },
                                            @{
                                                Title : @"非WIFI环境下播放提醒",
                                                CellClass : @"SetupSwitchCell",
                                                ExtraInfo : @(YES),
                                                ForbidSelect : @(YES)
                                             },
                                            @{
                                                Title : @"解码方式",
                                                DetailTitle : self.decodingWayString ? self.decodingWayString : @"未设置",
                                                CellAction : @"appearDecodingWayView"
                                             }
                                           ],
                            FooterTitle : @"",
                            FooterHeight : @(.1f)
                        },
                        @{
                            HeaderTitle : @"",
                            RowContent  : @[
                                            @{
                                                Title : @"关于我们",
                                                ShowAccessory : @(YES)
                                             },
                                            @{
                                                Title : @"问题反馈",
                                                ShowAccessory : @(YES)
                                             }
                                           ],
                            FooterTitle : @""
                        }
                    ];
    self.data = [CommonTableSection sectionWithData:data];
}
//建立view
- (void)initTableView
{
    [self.view addSubview:self.tableView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.decodingWayView];
}
#pragma mark -- 懒加载
- (DecodingWayView *)decodingWayView
{
    if (!_decodingWayView) {
        _decodingWayView = [[DecodingWayView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
        _decodingWayView.delegate = self;
        _decodingWayView.hidden = YES;
    }
    return _decodingWayView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kNavigationHeight) style:UITableViewStyleGrouped];
        __weak typeof(self) weakSelf = self;
        
        self.delegator = [[CommonTableDelegate alloc]initWithTableData:^NSArray *{
            return weakSelf.data;
        }];
        _tableView.dataSource = self.delegator;
        _tableView.delegate = self.delegator;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = tableViewBackGroundColor;
    }
    return _tableView;
}
#pragma mark -- DecodingWayDelegate
- (void)didSelectedDecodingWayButton:(NSUInteger)index withString:(NSString *)buttonString
{
    if (index == 0) {
        [self.decodingWayView hideView];
        self.decodingWayString = buttonString;
        [self initData];
        [self.tableView reloadData];
    }
    else if (index == 1)
    {
        [self.decodingWayView hideView];
        self.decodingWayString = buttonString;
        [self initData];
        [self.tableView reloadData];
    }
    else if (index == 2)
    {
        [self.decodingWayView hideView];
    }
}

#pragma mark - Action

- (void)barrageSetup
{
    BarrageSetupViewController *barrageSetC = [[BarrageSetupViewController alloc]init];
    barrageSetC.title = @"弹幕设置";
    [self.navigationController pushViewController:barrageSetC animated:YES];
}
- (void)appearDecodingWayView
{
    [self.decodingWayView appearView];
}
- (void)hideDecodingWayView
{
    [self.decodingWayView hideView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
