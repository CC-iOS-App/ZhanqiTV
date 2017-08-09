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
#import "MainTabController.h"
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
        //        [_advImage setImage:[UIImage imageNamed:@"loading.png"]];wwwww
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
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabController *mainTab = [[MainTabController alloc]initWithNibName:nil bundle:nil];
    self.window.rootViewController = mainTab;
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置状态栏为白色，在info文件中也做相应修改
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initRootController];
    
//    [self initAdvView];
    return YES;
}
@end
