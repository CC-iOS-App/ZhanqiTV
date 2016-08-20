//
//  MainTabController.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/22.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MainTabController.h"
#import "NavigationHandle.h"
#import "BaseNavViewController.h"
#define TabBarCount 4
#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"
typedef NS_ENUM(NSInteger,MainTabType){
    MainTabTypeHome,                //首页
    MainTabTypeLive,                //直播
    MainTabTypeEntertainment,       //娱乐
    MainTabTypeMine,                //我的
};
@interface MainTabController ()
@property (nonatomic, strong) NSArray *navigationHandlers;//导航handler数组

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,copy)  NSDictionary *configs;
@end

@implementation MainTabController

+ (instancetype)instance
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegate.window.rootViewController;
    if ([vc isKindOfClass:[MainTabController class]]) {
        return (MainTabController *)vc;
    }
    else
    {
        return nil;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpStatusBar];//设置状态栏
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubNav];//设置根视图
}
- (void)viewWillLayoutSubviews
{
    self.view.bounds = [UIScreen mainScreen].bounds;
}
- (void)setUpSubNav
{
    NSMutableArray *handleArray = [[NSMutableArray alloc]init];
    NSMutableArray *vcArray = [[NSMutableArray alloc]init];
    //数组遍历
    [self.tabbars enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *item = [self vcInfoForTabType:[obj integerValue]];
        NSString *vcName = item[TabbarVC];
        NSString *title = item[TabbarTitle];
        NSString *imageName = item[TabbarImage];
        NSString *imageSelected = item[TabbarSelectedImage];
        
//        正常来说，
//        id myObj = [[NSClassFromString(@"MySpecialClass") alloc] init];
//        和
//        id myObj = [[MySpecialClass alloc] init];
//        是一样的。但是，如果你的程序中并不存在MySpecialClass这个类，下面的写法会出错，而上面的写法只是返回一个空对象而已。
//        
//        因此，在某些情况下，可以使用NSClassFromString来进行你不确定的类的初始化。
//        NSClassFromString 好处
//        1 弱化连接，因此并不会把没有的Framework也link到程序中。
//        
//        2 不需要使用import，因为类是动态加载的，只要存在就可以加载。因此如果你的toolchain中没有某个类的头文件定义，而你确信这个类是可以用的，那么也可以用这种方法。
        Class clazz = NSClassFromString(vcName);
        
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        
        BaseNavViewController *nav = [[BaseNavViewController alloc]initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:imageSelected]];
        nav.tabBarItem.tag = idx;
        
        //根视图小红点计数，此处用不到
//        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
//        if (badge) {
//            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
//        }
        NavigationHandle *handler = [[NavigationHandle alloc]initWithNavigationController:nav];
        nav.delegate = handler;
        [vcArray addObject:nav];
        [handleArray addObject:handler];
        
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    self.tabBar.tintColor = navigationBarColor;
    self.navigationHandlers = [NSArray arrayWithArray:handleArray];
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
                     @(MainTabTypeLive) : @{
                             TabbarVC           : @"LiveViewController",
                             TabbarTitle        : @"直播",
                             TabbarImage        : @"tabbar_live",
                             TabbarSelectedImage: @"tabbar_live_sel"
                             },
                     @(MainTabTypeEntertainment) : @{
                             TabbarVC           : @"EntertainmentViewController",
                             TabbarTitle        : @"娱乐",
                             TabbarImage        : @"tabbar_entertainment",
                             TabbarSelectedImage: @"tabbar_entertainment_sel"
                             },
                     @(MainTabTypeMine) : @{
                             TabbarVC           : @"MineViewController",
                             TabbarTitle        : @"我的",
                             TabbarImage        : @"tabbar_mine",
                             TabbarSelectedImage: @"tabbar_mine_sel"
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
- (void)setUpStatusBar
{
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
