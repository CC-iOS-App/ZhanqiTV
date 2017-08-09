//
//  MainTabController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/22.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MainTabController.h"
#import "BaseNavViewController.h"
NSUInteger const TabBarCount = 4;
NSString * const TabbarVC = @"vc";
NSString * const TabbarTitle = @"title";
NSString * const TabbarImage = @"imageName";
NSString * const TabbarSelectedImage = @"selectedImageName";
NSString * const TabbarItemBadgeValue = @"badgeValue";

typedef NS_ENUM(NSInteger,MainTabType){
    MainTabTypeHome,                //首页
    MainTabTypeEntertainment,       //娱乐
    MainTabTypeAttention,           //关注
    MainTabTypeMine,                //我的
};
@interface MainTabController ()
@property (readonly, nonatomic, strong) NSArray *tabbars;
@property (readwrite, nonatomic, assign) NSInteger sessionUnreadCount;
@property (readwrite, nonatomic, strong)  NSDictionary *configs;
@end

@implementation MainTabController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setUpStatusBar];//设置状态栏
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}
- (void)setSubViews
{
    NSMutableArray *vcArray = [[NSMutableArray alloc]init];
    //数组遍历
    [self.tabbars enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull __unused stop) {
        NSDictionary *items = [self vcInfoForTabType:[obj integerValue]];
        
        NSString *vcName = items[TabbarVC];
        NSString *vcTitle = items[TabbarTitle];
        NSString *imageName = items[TabbarImage];
        NSString *imageSelectedName = items[TabbarSelectedImage];
        
        Class clazz = NSClassFromString(vcName);
        UIViewController *vc = [[clazz alloc]init];
        vc.automaticallyAdjustsScrollViewInsets = NO;
        vc.hidesBottomBarWhenPushed = NO;
        
        BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:vcTitle image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:imageSelectedName]];
        nav.tabBarItem.tag = index;
        [vcArray addObject:nav];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    
    self.tabBar.tintColor = navigationBarColor;
}
- (NSDictionary *)vcInfoForTabType:(MainTabType)type
{
    if (_configs == nil) {
        _configs = @{
                     @(MainTabTypeHome) : @{
                             TabbarVC           : @"HomeViewController",
                             TabbarTitle        : @"首页",
                             TabbarImage        : @"tabbar_home",
                             TabbarSelectedImage: @"tabbar_home_sel"
                             },
                     @(MainTabTypeEntertainment) : @{
                             TabbarVC           : @"EntertainmentViewController",
                             TabbarTitle        : @"娱乐",
                             TabbarImage        : @"tabbar_entertain",
                             TabbarSelectedImage: @"tabbar_entertain_sel"
                             },
                     @(MainTabTypeAttention) : @{
                             TabbarVC           : @"LiveViewController",
                             TabbarTitle        : @"关注",
                             TabbarImage        : @"tabbar_subscribe",
                             TabbarSelectedImage: @"tabbar_subscribe_sel"
                             },
                     @(MainTabTypeMine) : @{
                             TabbarVC           : @"MineViewController",
                             TabbarTitle        : @"我的",
                             TabbarImage        : @"tabbar_me",
                             TabbarSelectedImage: @"tabbar_me_sel"
                             }
                     };
    }
    return _configs[@(type)];
}

- (NSArray *)tabbars
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (NSInteger tabbar = 0; tabbar < TabBarCount; tabbar++) {
        [items addObject:@(tabbar)];
    }
    return items;
}
@end
