//
//  InputEmoticonButton.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
//表情按钮
#import <UIKit/UIKit.h>

@class InputEmoticon;

@protocol EmoticonButtonTouchDelegate <NSObject>

- (void)selectedEmoticon:(InputEmoticon *)emoticon catalogID:(NSString *)catalogID;
@end


@interface InputEmoticonButton : UIButton

@property (nonatomic, weak) id<EmoticonButtonTouchDelegate> delegate;
@property (nonatomic, copy) NSString *catalogID;

@property (nonatomic, strong) InputEmoticon *emoticonData;

+ (InputEmoticonButton *)iconButtonWithData:(InputEmoticon *)data catalogID:(NSString *)catalogID delegate:(id<EmoticonButtonTouchDelegate>)delegate;

- (void)onIconSelected:(id)sender;
@end
