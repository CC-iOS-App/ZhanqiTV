//
//  InputMessageObjectProtocol.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputMessageGlobal.h"
@class InputMessage;

@protocol InputMessageObject <NSObject>

/**
 *  消息体所在的消息对象
 */
@property (nullable,nonatomic, weak) InputMessage *message;

/**
 *  消息内容类型
 *
 *  @return 消息内容类型
 */
- (InputMessageType)type;
@end
