//
//  MineViewController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeadCell.h"
@interface MineViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation MineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initData];
}
#pragma mark -- initData
- (void)initData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MineData" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:plistPath];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = (MineHeadCell *)[tableView dequeueReusableCellWithIdentifier:@"MineHeadCell"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    if (!cell) {
        if (indexPath.section == 0) {
            
        }else{
            
        }
    }
    
    return cell;
}

#pragma mark - TableViewDelegate


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

}
@end
