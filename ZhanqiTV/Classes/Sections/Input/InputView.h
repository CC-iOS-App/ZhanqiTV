//
//  InputView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTextFiled.h"
#import "InputProtocol.h"
#import "SessionCofig.h"

@class InputMoreContainerView;
@class InputEmoticonContainerView;
@class InputToolBar;
typedef NS_ENUM(NSInteger,InputType){
    InputTypeText = 1,
    InputTypeEmot = 2,
    InputTypeMeidia = 3,
    InputTypeGift = 4,
};

@protocol InputDelegate <NSObject>

@optional
- (void)showInputView;
- (void)hideInputView;

- (void)inputViewSizeToHeight:(CGFloat)toHeight
                showInputView:(BOOL)show;

@end
@interface InputView : UIView

@property (nonatomic, assign) NSInteger         maxTextLength;//最大文字输入
@property (nonatomic, assign) CGFloat           inputBottomViewHeight;//toolbar底部view高度

@property (nonatomic, assign, getter=isRecording) BOOL recording;

@property (nonatomic, strong) InputToolBar *toolBar;//小横条输入框
@property (nonatomic, strong) InputEmoticonContainerView *emoticonContainer;//表情view
@property (nonatomic, strong) InputMoreContainerView *moreContainer;//更多媒体view

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setInputDelegate:(id<InputDelegate>)delegate;//

//外部设置
- (void)setInputActionDelegate:(id<InputActionDelegate>)actionDelegate;

- (void)setInputConfig:(id<SessionCofig>)config;

/**
 *  设置提示文字
 *
 *  @param placeHolder          未输入文字时显示
 */
- (void)setInputTextPlaceHolder:(NSString *)placeHolder;
@end
