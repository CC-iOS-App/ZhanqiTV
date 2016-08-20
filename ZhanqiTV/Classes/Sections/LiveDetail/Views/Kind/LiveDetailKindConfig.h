//
//  LiveDetailKindConfig.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiveDetailKindItem;

typedef NS_ENUM(NSInteger, LiveDetailType)
{
    LiveDetailTypeIntroduction  = 0,        //简介
    LiveDetailTypeChat,                     //聊天
    LiveDetailTypeActive,                   //活动
    LiveDetailTypeRanking,                  //排行
};
@interface LiveDetailKindConfig : NSObject
+ (NSArray<LiveDetailKindItem *> *)detailItem;
@end
