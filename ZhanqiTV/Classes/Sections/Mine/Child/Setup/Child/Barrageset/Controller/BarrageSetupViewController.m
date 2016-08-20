//
//  BarrageSetupViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "BarrageSetupViewController.h"
#import "CommonTableData.h"
#import "CommonTableDelegate.h"
@interface BarrageSetupViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommonTableDelegate *delegator;
@property (nonatomic, strong) NSArray *data;
@end

@implementation BarrageSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildData];
    [self initTableView];
}

- (void)buildData
{
    NSArray *data = @[
                      @{
                          HeaderTitle : @"",
                          RowContent  : @[
                                            @{
                                                Title : @"弹幕开关",
                                                CellClass : @"SetupSwitchCell",
                                                ExtraInfo : @(NO),
                                                RowHeight : @(58.f)
                                            },
                                            @{
                                                Title : @"弹幕透明度",
                                                CellClass : @"BarrageTransparencyCell",
                                                RowHeight : @(100.f)
                                            },
                                            @{
                                                Title : @"弹幕大小",
                                                CellClass : @"BarrageSizeCell",
                                                RowHeight : @(130.f)
                                            },
                                            @{
                                                Title : @"弹幕位置",
                                                CellClass : @"BarragePositionCell",
                                                RowHeight : @(81.f)
                                            }
                                          ],
                          FooterTitle  : @""
                        }
                     ];
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
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = tableViewBackGroundColor;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        __weak typeof(self) weakSelf = self;
        self.delegator = [[CommonTableDelegate alloc]initWithTableData:^NSArray *{
            return weakSelf.data;
        }];
        _tableView.dataSource = self.delegator;
        _tableView.delegate = self.delegator;
        _tableView.bounces = NO;
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
