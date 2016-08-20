//
//  InputMessage.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputMessageGlobal.h"
#import "InputSession.h"
#import "InputMessageObjectProtocol.h"
@class InputMessageChatroomExtension;

/**
 *  消息送达状态枚举
 */
typedef NS_ENUM(NSInteger, InputMessageDeliverState)
{
    /**
     *  消息发送失败
     */
    InputMessageDeliverStateFailed,
    
    /**
     *  消息发送中
     */
    InputMessageDeliverStateDelivering,
    /**
     *  消息发送成功
     */
    InputMessageDeliverStateDeliveried
};

/**
 *  消息体协议
 */
@protocol InputMessageObject;

/**
 *  消息结构
 */
@interface InputMessage : NSObject

/**
 *  消息类型
 */
@property (nonatomic,assign,readonly)       InputMessageType messageType;

/**
 *  消息来源
 */
@property (nullable,nonatomic,copy)                  NSString *from;

/**
 *  消息所属会话
 */
@property (nullable,nonatomic,copy,readonly)       InputSession *session;

/**
 *  消息ID,唯一标识
 */
@property (nonatomic,copy,readonly)         NSString *messageId;

/**
 *  消息文本
 *  @discussion 聊天室消息中除 NIMMessageTypeText 和 NIMMessageTypeTip 外，其他消息 text 字段都为 nil
 */
@property (nullable,nonatomic,copy)                  NSString *text;
/**
 *  消息推送文案,长度限制200字节
 */
@property (nullable,nonatomic,copy)                  NSString *apnsContent;

@end
