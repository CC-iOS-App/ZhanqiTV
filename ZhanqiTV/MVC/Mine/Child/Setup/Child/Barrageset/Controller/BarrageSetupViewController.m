//
//  BarrageSetupViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "BarrageSetupViewController.h"
#import "BarrageTransparencyCell.h"//弹幕透明度cell
#import "BarrageSizeCell.h"//弹幕大小cell
#import "BarragePositionCell.h"//弹幕位置cell
@interface BarrageSetupViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *mySwitch;
@end

@implementation BarrageSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 58.0f;
            break;
        case 1:
            return 100.0f;
            break;
        case 2:
            return 130.0f;
            break;
        case 3:
            return 81.0f;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifer = @"Cell";
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            [self.mySwitch setOn:YES animated:YES];
            cell.textLabel.text = @"弹幕开关";
            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            cell.accessoryView = self.mySwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (indexPath.row == 1)
    {
        BarrageTransparencyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[BarrageTransparencyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (indexPath.row == 2)
    {
        BarrageSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[BarrageSizeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (indexPath.row == 3)
    {
        BarragePositionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[BarragePositionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 10)];
    
    headerView.backgroundColor = tableViewBackGroundColor;
    return headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
