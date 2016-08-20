//
//  InputSession.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, InputSessionType){
    /**
     *  点对点
     */
    InputSessionTypeP2P  = 0,
    /**
     *  群组
     */
    InputSessionTypeTeam = 1,
    /**
     *  聊天室
     */
    InputSessionTypeChatroom = 2
};

/**
 *  会话对象
 */
@interface InputSession : NSObject<NSCoding>
/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic,copy,readonly)         NSString *sessionId;

/**
 *  会话类型,当前仅支持P2P,Team和Chatroom
 */
@property (nonatomic,assign,readonly)       InputSessionType sessionType;


/**
 *  通过id和type构造会话对象
 *
 *  @param sessionId   会话ID
 *  @param sessionType 会话类型
 *
 *  @return 会话对象实例
 */
+ (instancetype)session:(NSString *)sessionId
                   type:(InputSessionType)sessionType;
@end
