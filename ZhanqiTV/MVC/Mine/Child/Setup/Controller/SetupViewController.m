//
//  SetupViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "SetupViewController.h"
#import "BarrageSetupViewController.h"
@interface SetupViewController ()<DecodingWayDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DecodingWayView *decodingWayView;
@property (nonatomic, strong) UISwitch *mySwitch;
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
    _dataArray = @[@[@"弹幕设置",@"清除系统缓存",@"非WIFI环境下播放提醒",@"解码方式"],@[@"关于我们",@"问题反馈"]];
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = tableViewBackGroundColor;
    }
    return _tableView;
}
- (UISwitch *)mySwitch
{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    }
    return _mySwitch;
}
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
        
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self clearAllCashesSize]];
            }
                break;
            case 2:
            {
                [self.mySwitch setOn:self.switchIsOn animated:YES];
                cell.accessoryView = self.mySwitch;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            case 3:
            {
                cell.detailTextLabel.text = self.decodingWayString;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                BarrageSetupViewController *barrageSetC = [[BarrageSetupViewController alloc]init];
                barrageSetC.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
                [self.navigationController pushViewController:barrageSetC animated:YES];
            }
                break;
            case 1:
            {

            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                [self.decodingWayView appearView];
            }
                break;
            default:
                break;
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark -- DecodingWayDelegate
- (void)didSelectedDecodingWayButton:(NSUInteger)index withString:(NSString *)buttonString
{
    if (index == 0) {
        [self.decodingWayView hideView];
        self.decodingWayString = buttonString;
        [self.tableView reloadData];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (index == 1)
    {
        [self.decodingWayView hideView];
        self.decodingWayString = buttonString;
        [self.tableView reloadData];
    }
    else if (index == 2)
    {
        [self.decodingWayView hideView];
    }
}
- (void)hideDecodingWayView
{
    [self.decodingWayView hideView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
