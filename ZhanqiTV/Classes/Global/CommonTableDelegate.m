//
//  CommonTableDelegate.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/29.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "CommonTableDelegate.h"
#import "CommonTableData.h"
#import "CommonTableViewCell.h"
#import "UIView+ZhanqiTVKit.h"
#import "GlobalMacro.h"

#define SepViewTag 10001

static NSString *DefaultTableCell = @"UITableViewCell";
@interface CommonTableDelegate()
@property (nonatomic, copy) NSArray *(^DataReceiver)(void);//数组回调
@end

@implementation CommonTableDelegate
- (instancetype)initWithTableData:(NSArray *(^)(void))data
{
    self = [super init];
    if (self) {
        _DataReceiver = data;
        _defaultSeparatorLeftEdge = SepLineLeft;
    }
    return self;
}

- (NSArray *)data
{
    return self.DataReceiver();
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    
    return tableSection.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableSection  *tableSection = self.data[indexPath.section];
    CommonTableRow      *tableRow = tableSection.rows[indexPath.row];
    NSString *identifier = tableRow.cellClassName.length ? tableRow.cellClassName : DefaultTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        Class clazz = NSClassFromString(identifier);
        cell = [[clazz alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        UIView *sep = [[UIView alloc]initWithFrame:CGRectZero];
//        sep.tag = SepViewTag;
//        sep.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;//view的宽度按照父视图的宽度比例进行缩放，距离父视图底部和右部距离不变。
//        sep.backgroundColor = [UIColor lightGrayColor];
//        [cell addSubview:sep];
    }
    if (![cell respondsToSelector:@selector(refreshData:tableView:)]) {
        UITableViewCell *defaultCell = (UITableViewCell *)cell;
        [self refreshData:tableRow cell:defaultCell];
    }
    else
    {
        [(id<CommonTableViewCell>)cell refreshData:tableRow tableView:tableView];
    }
    cell.selectionStyle = tableRow.disSelected ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    cell.accessoryType = tableRow.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableSection  *tableSection = self.data[indexPath.section];
    CommonTableRow      *tableRow = tableSection.rows[indexPath.row];
    
    return tableRow.uiRowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableSection  *tableSection  = self.data[indexPath.section];
    CommonTableRow      *tableRow      = tableSection.rows[indexPath.row];
    if (!tableRow.forbidSelect) {//相应事件
        UIViewController *vc = tableView.nim_viewController;
        NSString *actionName = tableRow.cellActionName;
        if (actionName.length) {
            SEL sel = NSSelectorFromString(actionName);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NIMKit_SuppressPerformSelectorLeakWarning([vc performSelector:sel withObject:cell]);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTableSection  *tableSection = self.data[indexPath.section];
    CommonTableRow      *tableRow = tableSection.rows[indexPath.row];
    
    UIView *sep = [cell viewWithTag:SepViewTag];
    CGFloat sepHeight = .5f;
    CGFloat sepWidth;
    if (tableRow.sepLeftEdge) {
        sepWidth = cell.frame.size.width - tableRow.sepLeftEdge;
    }else
    {
        if (indexPath.row == tableSection.rows.count - 1) {
            //最后一行
            sepWidth = 0;
        }else
        {
            sepWidth = self.defaultSeparatorLeftEdge;
        }
    }
    sepWidth = sepWidth > 0 ? sepWidth : 0;
    sep.frame = CGRectMake(sepWidth, sepHeight, sepWidth, sepHeight);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    
    return tableSection.headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    return tableSection.headerTitle.length ? [tableSection.headerTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]}].height : tableSection.uiHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    if (tableSection.headerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    
    return tableSection.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];

    return tableSection.footerTitle.length ? [tableSection.footerTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]}].height : tableSection.uiFooterHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CommonTableSection *tableSection = self.data[section];
    if (tableSection.footerTitle.length) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    
    return view;
}

#pragma mark - Private
- (void)refreshData:(CommonTableRow *)rowData cell:(UITableViewCell *)cell
{
    cell.textLabel.text = rowData.title;
    cell.detailTextLabel.text = rowData.detailTitle;
    cell.imageView.image = rowData.imageName ? [UIImage imageNamed:rowData.imageName] : [UIImage imageNamed:@""];
}
@end
