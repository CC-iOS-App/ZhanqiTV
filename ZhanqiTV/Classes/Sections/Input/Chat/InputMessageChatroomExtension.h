//
//  InputMessageChatroomExtension.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputMessageChatroomExtension : NSObject

/**
 *  用户在聊天室内的昵称
 */
@property (nonatomic, nullable, copy) NSString      *roomNickName;
/**
 *  用户在聊天室内的头像
 */
@property (nullable, nonatomic, copy) NSString      *roomAvatar;
@end
