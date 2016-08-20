//
//  InputSessionConfig.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionCofig.h"

typedef NS_ENUM(NSInteger,InputMediaButton)
{
    InputMediaButtonSlotMachines = 0,       //老虎机
    InputMediaButtonChatMode,               //聊天模式
    InputMediaButtonShare,                  //分享
    InputMediaButtonTopUp,                  //充值
    InputMediaButtonSignIn,                 //签到
    InputMediaButtonSet,                    //设置
    InputMediaButtonFireworks,              //烟花
};
@interface InputSessionConfig : NSObject<SessionCofig>
//@property (nonatomic, strong)

@end
