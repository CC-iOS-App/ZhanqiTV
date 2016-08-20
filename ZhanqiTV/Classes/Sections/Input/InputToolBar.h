//
//  InputToolBar.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InputTextFiled;
@interface InputToolBar : UIView

@property (nonatomic, strong) UIButton *emoticonBtn;//表情

@property (nonatomic, strong) UIView *emoticonAndTextBackGroundView;//存放表情和输入文本的view
//@property (nonatomic, strong) UIImageView *inputTextBackGroundImage;
@property (nonatomic, strong) InputTextFiled *inputTextFiled;//文字输入
@property (nonatomic, strong) UIButton *giftBtn;//礼物
@property (nonatomic, strong) UIButton *moreMediaBtn;//更多
//@property (nonatomic, assign) BOOL showGiftBtn;//是否隐藏礼物按钮

- (void)setInputBarItemTypes:(NSArray<NSNumber *> *)types;
//- (void)isShowGiftBtn:(BOOL)show;//是否隐藏礼物按钮方法

@end
