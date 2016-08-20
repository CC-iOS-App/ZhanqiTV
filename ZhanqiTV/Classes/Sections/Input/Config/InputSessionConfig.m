//
//  InputSessionConfig.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputSessionConfig.h"
#import "MediaItem.h"
@implementation InputSessionConfig

- (NSArray *)mediaItems
{
    return @[[MediaItem item:InputMediaButtonSlotMachines
                 normalImage:[UIImage imageNamed:@"more_tiger"]
            highlightedImage:[UIImage imageNamed:@"more_tiger_disable"]
               selectedImage:[UIImage imageNamed:@"more_tiger"]
                       title:@"老虎机"],
             [MediaItem item:InputMediaButtonChatMode
                 normalImage:[UIImage imageNamed:@"more_chat"]
            highlightedImage:[UIImage imageNamed:@"more_chat"]
               selectedImage:[UIImage imageNamed:@"more_camera"]
                       title:@"聊天模式"],
             [MediaItem item:InputMediaButtonShare
                 normalImage:[UIImage imageNamed:@"more_share"]
            highlightedImage:[UIImage imageNamed:@"more_share"]
               selectedImage:[UIImage imageNamed:@"more_share"]
                       title:@"分享"],
             [MediaItem item:InputMediaButtonTopUp
                 normalImage:[UIImage imageNamed:@"more_recharge"]
            highlightedImage:[UIImage imageNamed:@"more_recharge"]
               selectedImage:[UIImage imageNamed:@"more_recharge"]
                       title:@"充值"],
             [MediaItem item:InputMediaButtonSignIn
                 normalImage:[UIImage imageNamed:@"more_sign"]
            highlightedImage:[UIImage imageNamed:@"more_signed"]
               selectedImage:[UIImage imageNamed:@"more_signed"]
                       title:@"签到"],
             [MediaItem item:InputMediaButtonSet
                 normalImage:[UIImage imageNamed:@"more_setting"]
            highlightedImage:[UIImage imageNamed:@"more_setting"]
               selectedImage:[UIImage imageNamed:@"more_setting"]
                       title:@"设置"],
             [MediaItem item:InputMediaButtonFireworks
                 normalImage:[UIImage imageNamed:@"more_fire_normal"]
            highlightedImage:[UIImage imageNamed:@"more_fire_selected"]
               selectedImage:[UIImage imageNamed:@"more_fire_normal"]
                       title:@"烟花"]
             ];
}

- (BOOL)shouldHideItem:(MediaItem *)item
{
    BOOL hidden = NO;
    return hidden;
}
@end
