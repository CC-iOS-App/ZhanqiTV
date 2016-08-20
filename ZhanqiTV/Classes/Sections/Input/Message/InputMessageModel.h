//
//  InputMessageModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionCofig.h"
#import "InputMessageGlobal.h"
#import "InputMessage.h"


@interface InputMessageModel : NSObject

/**
 *  消息数据
 */
@property (nonatomic, strong) InputMessage *message;
/**
 *  消息来源   
 *  nullable 可以为nil或NULL
 */
@property (nonatomic, copy,nullable)        NSString *from;

- (instancetype)initWithMessage:(InputMessage *)message;

- (void)cleanCache;
@end
