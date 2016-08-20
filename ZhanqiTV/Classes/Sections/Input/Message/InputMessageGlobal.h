//
//  InputMessageGlobal.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#ifndef InputMessageGlobal_h
#define InputMessageGlobal_h

/**
 *  消息内容类型枚举
 */
typedef NS_ENUM(NSInteger,InputMessageType)
{
    /**
     *  文本类型消息
     */
    InputMessageTypeText            = 0,
    
    /**
     *  图片类型消息
     */
    InputMessageTypeImage           = 1,
    
    /**
     *  礼物类型消息
     */
    InputMessageTypeGift            = 2,
    
    /**
     *  通知类型消息
     */
    InputMessageTypeNotification    = 3,
    
    /**
     *  提醒类型消息
     */
    InputMessageTypeTip             = 10,
    
    /**
     *  文本类型消息
     */
    InputMessageTypeCustom          = 100
};

/**
 *  直播视频质量
 */
typedef NS_ENUM(NSInteger, InputNetLiveVideoQuality){
    
    /**
     *  流畅
     */
    InputNetLiveVideoQualitySmooth              = 0,
    /**
     *  标清
     */
    InputNetLiveVideoQualityStandardDefinition  = 1,
    /**
     *  高清
     */
    InputNetLiveVideoQualityHD                  = 2,
    /**
     *  超清
     */
    InputNetLiveVideoQualitySuperClear          = 3,
};

#endif /* InputMessageGlobal_h */
