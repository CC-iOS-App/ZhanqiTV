//
//  MineViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MineViewController.h"
#import "SetupViewController.h"
#import "OfficialAnnouncementViewController.h"
#import "MineHeaderTableCell.h"
@interface MineViewController ()<MineHeaderViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_cellArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initTableView];
}
#pragma mark -- initData
- (void)initData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MineData" ofType:@"plist"];
    _cellArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cellArray.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0? 1 : [_cellArray[section-1] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifer = @"headerCell";
        
        MineHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[MineHeaderTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.name = @"路飞";
        cell.gold = @"2222";
        cell.coin = @"333";
        [cell addLoginedView];
        return cell;
    }
    else
    {
        static NSString *cellIdentifer = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.textLabel.text = [_cellArray[indexPath.section-1][indexPath.row] objectForKey:@"title"];
            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
            cell.imageView.image = [UIImage imageNamed:[_cellArray[indexPath.section-1][indexPath.row] objectForKey:@"image"]];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    
}
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!(section == 0)) {
        return 10.0f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 164.0f;
    }
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            OfficialAnnouncementViewController *vc = [[OfficialAnnouncementViewController alloc]init];
            
            vc.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark -- MineHeaderViewCellDelegate
- (void)didSelectInfoButton:(NSUInteger)index
{
    if (index == 0) {
        SetupViewController *vc = [[SetupViewController alloc]init];
        
        vc.title = @"设置";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        NSLog(@"头像");
    }
    else if (index == 2)
    {
        NSLog(@"昵称");
    }
    else if (index == 3)
    {
        NSLog(@"充值");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
