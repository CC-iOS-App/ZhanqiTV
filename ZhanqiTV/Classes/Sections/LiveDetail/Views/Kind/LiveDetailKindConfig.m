//
//  LiveDetailKindConfig.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LiveDetailKindConfig.h"
#import "LiveDetailKindItem.h"
@implementation LiveDetailKindConfig

+ (NSArray<LiveDetailKindItem *> *)detailItem
{
    return @[[LiveDetailKindItem item:LiveDetailTypeIntroduction
                          normalImage:[UIImage imageNamed:@"ic_broadcastroom_intro_default"]
                     highlightedImage:[UIImage imageNamed:@"ic_broadcastroom_intro_pressed"]
                        selectedImage:[UIImage imageNamed:@"ic_broadcastroom_intro_pressed"]
                                title:@"简介"],
             [LiveDetailKindItem item:LiveDetailTypeChat
                          normalImage:[UIImage imageNamed:@"ic_broadcastroom_chat_default"]
                     highlightedImage:[UIImage imageNamed:@"ic_broadcastroom_chat_pressed"]
                        selectedImage:[UIImage imageNamed:@"ic_broadcastroom_chat_pressed"]
                                title:@"聊天"],
             [LiveDetailKindItem item:LiveDetailTypeActive
                          normalImage:[UIImage imageNamed:@"ic_broadcastroom_video_default"]
                     highlightedImage:[UIImage imageNamed:@"ic_broadcastroom_video_pressed"]
                        selectedImage:[UIImage imageNamed:@"ic_broadcastroom_video_pressed"]
                                title:@"活动"],
             [LiveDetailKindItem item:LiveDetailTypeRanking
                          normalImage:[UIImage imageNamed:@"ic_broadcastroom_rank_default"]
                     highlightedImage:[UIImage imageNamed:@"ic_broadcastroom_rank_pressed"]
                        selectedImage:[UIImage imageNamed:@"ic_broadcastroom_rank_pressed"]
                                title:@"排行"]
             ];
}
@end
