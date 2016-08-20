//
//  UIConfig.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIConfig : NSObject

//输入框上部高度
+ (CGFloat)topInputViewHeight;

//输入框下部高度(内容区域)
+ (CGFloat)bottomInputViewHeight;

//默认消息条数
+ (NSInteger)messageLimit;

//会话列表中时间打点间隔
+ (NSTimeInterval)messageTimeInterval;
@end
