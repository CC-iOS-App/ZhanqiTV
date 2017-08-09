//
//  Constants.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
// 1.判断是否为iOS7或者更高版本
#define iOS7     ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define iOS8     ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//当前版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 2.获取RGB颜色
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)         RGBA(r,g,b,1.0f)

#define navigationBarColor  RGB(84, 181, 239)
#define separaterColor      RGB(200, 199, 204)
#define tableViewBackGroundColor RGB(234,239,245)
#define MineHeaderBackGroundColor RGB(33,184,240)
// 3.是否为4inch
#define fourInch            ([UIScreen mainScreen].bounds.size.height == 568)

// 4.屏幕尺寸大小
extern float kScreenFactor;
extern float kScreen_width;
extern float kScreen_height;
//#define kScreen_width        [UIScreen mainScreen].bounds.size.width
//#define kScreen_height       [UIScreen mainScreen].bounds.size.height
#define kNavigationHeight       64
#define kNavigationBarHeight    44
#define kStatusBarHeight        20
#define kTabbarHeight           49

//重新设定view的坐标以及长宽
#define setFrameX(view,newX)            view.frame = CGRectMake(newX, view.frame.origin.y,view.frame.size.width, view.frame.size.height)
#define setFrameY(view,newY)            view.frame = CGRectMake(view.frame.origin.x, newY,view.frame.size.width, view.frame.size.height)
#define setFrameWidth(view,newWidth)    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,newWidth, view.frame.size.height)
#define setFrameHeight(view,newHeight)  view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y,view.frame.size.width, newHeight)

//取view的坐标以及长宽
#define viewX(view)         view.frame.origin.x
#define viewY(view)         view.frame.origin.y
#define viewWidth(view)     view.frame.size.width
#define viewHeight(view)    view.frame.size.height

// 5.经纬度
#define LATITUDE_DEFAULT 39.983497
#define LONGITUDE_DEFAULT 116.318042

// 6.主机地址
#define PREFIX_URL @"http://www.zhanqi.tv/api/"
#define HLS_URL @"http://dlhls.cdn.zhanqi.tv/zqlive/"//视频播放

// 7.默认间距
#define LiveCellControlDistance 10   //视频播放页面控件间距

// 8.两次网络请求时间间隔
#define NetworkRequestInterval    120


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* Constants_h */
