//
//  SessionCofig.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/5.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaItem.h"
#import "InputBarItemType.h"
@protocol SessionCofig <NSObject>

@optional

/**
 *  输入按钮类型，请填入 NIMInputBarItemType 枚举，按顺序排列。不实现则按默认排列。
 */
- (NSArray<NSNumber *> *)inputBarItemTypes;


/**
 *  可以显示在点击输入框“+”按钮之后的多媒体按钮
 */
- (NSArray<MediaItem *> *)mediaItems;

/**
 *  禁用贴图表情
 */
- (BOOL)disableCharlet;

/**
 *  是否隐藏多媒体按钮
 *  @param item 多媒体按钮
 */
- (BOOL)shouldHideItem:(MediaItem *)item;

/**
 *  是否禁用输入控件
 */
- (BOOL)disableInputView;

/**
 *  输入控件最大输入长度
 */
- (NSInteger)maxInputLength;

/**
 *  输入控件placeholder
 *
 *  @return placeholder
 */
- (NSString *)inputViewPlaceholder;
@end
