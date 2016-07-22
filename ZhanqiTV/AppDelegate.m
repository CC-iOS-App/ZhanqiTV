//
//  AppDelegate.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/15.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "AppDelegate.h"
#import "ZhanqiTVHeader.pch"
float kScreen_width = 320.0;
float kScreen_height = 568.0;
float kScreenFactor =1.0;
@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)initAdvView{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isExit) {
        NSLog(@"存在");
        _advImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
        //        [_advImage setImage:[UIImage imageNamed:@"loading.png"]];
        [_advImage setImage:[UIImage imageWithContentsOfFile:filePath]];
        [self.window addSubview:_advImage];
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //加载启动广告并保存到本地沙盒，因为保存的图片较大，每次运行都要保存，所以注掉了
            [self getLoadingImage];
        });
    }else{
        NSLog(@"不存在");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getLoadingImage];
        });
    }
}
-(void)getLoadingImage{
    //分辨率
//    CGFloat scale_screen = [UIScreen mainScreen].scale;
//    NSLog(@"%.0f    %.0f",screen_width*scale_screen,screen_height*scale_screen);
//    int scaleW = (int)screen_width*scale_screen;
//    int scaleH = (int)screen_height*scale_screen;
    
    NSString *urlStr = @"public/app.loading_ad";
    
    [NetworkSingleton httpGET:urlStr headerWithUserInfo:YES parameters:nil successBolock:^(NSDictionary *responseBody) {
        NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (dataArray.count>0) {
                NSString *picUrl = [NSString stringWithFormat:@"mobile%@x%@",@"750",@"1334"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[dataArray[0] objectForKey:@"pic"] objectForKey:picUrl]]];
                UIImage *image = [UIImage imageWithData:data];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];   // 保存文件的名称
                //    BOOL result = [UIImagePNGRepresentation() writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
                NSLog(@"paths:%@    %@",paths,filePath);
                [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                
            }
        });
    } failureBlock:^(NSError *error) {
        NSLog(@"获取启动广告图片失败：%@",error);
    }];
}
-(void)removeAdvImage{
    [UIView animateWithDuration:0.3f animations:^{
        _advImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _advImage.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_advImage removeFromSuperview];
    }];
}
#pragma mark -- 设置根视图
- (void)initRootController
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    HomeViewController *home = [[HomeViewController alloc]init];
    BaseNavViewController *homeNav = [[BaseNavViewController alloc]initWithRootViewController:home];
    
    LiveViewController *live = [[LiveViewController alloc]init];
    BaseNavViewController *liveNav = [[BaseNavViewController alloc]initWithRootViewController:live];
    
    EntertainmentViewController *entertainment = [[EntertainmentViewController alloc]init];
    BaseNavViewController *entertainmentNav = [[BaseNavViewController alloc]initWithRootViewController:entertainment];
    
    MineViewController *mine = [[MineViewController alloc]init];
    BaseNavViewController *mineNav = [[BaseNavViewController alloc]initWithRootViewController:mine];
    
    homeNav.title = @"首页";
    homeNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
//    homeNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// 始终绘制图片原始状态，不使用Tint Color。
    liveNav.title = @"直播";
    liveNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_live"];
    
    entertainmentNav.title = @"娱乐";
    entertainmentNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_entertainment"];
    
    mineNav.title = @"我的";
    mineNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_mine"];
    
    
    NSArray *viewControllers = @[homeNav,liveNav,entertainmentNav,mineNav];
    [self.rootTabbarController setViewControllers:viewControllers animated:YES];
    self.window.rootViewController = self.rootTabbarController;
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置状态栏为白色，在info文件中也做相应修改
    [self.window makeKeyAndVisible];
}
- (UITabBarController *)rootTabbarController
{
    if (!_rootTabbarController) {
        _rootTabbarController = [[UITabBarController alloc]init];
        _rootTabbarController.tabBar.tintColor = navigationBarColor;
    }
    return _rootTabbarController;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启用网络接口日志
//    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    kScreen_width = [UIScreen mainScreen].bounds.size.width;
    kScreen_height = [UIScreen mainScreen].bounds.size.height;
    kScreenFactor = kScreen_height <= 568.0 ? 1.0 : kScreen_height / 568.0;
    [self initRootController];
    
    [self initAdvView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
