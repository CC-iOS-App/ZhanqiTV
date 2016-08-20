//
//  InputTextFiled.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/15.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputTextFiled.h"

@implementation InputTextFiled

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeHolder) {//如果没有文字输入 并且有placeHolder存在
        CGRect placeHolderRect = CGRectMake(2.f, 7.f, rect.size.width, rect.size.height);
        //placeHolder所在位置和长度
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment = self.textAlignment;//文字对齐方式
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略，显示头的文字内容
        [self.placeHolder drawInRect:placeHolderRect withAttributes:@{NSFontAttributeName : self.font,NSForegroundColorAttributeName : [UIColor lightGrayColor],NSParagraphStyleAttributeName : paragraphStyle}];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;//如果设置的与已有一样，返回
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];//调用绘图drawRect
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];//调用绘图drawRect
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];//调用绘图drawRect
}
//TODO: init方法，下面还有个外部接口setcustomUI,两个不能同时使用
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self cutomUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];//调用当textfield改变后通知
    }
    return self;
}

- (void)cutomUI
{
    self.userInteractionEnabled = YES;//可交互
    self.backgroundColor        = [UIColor clearColor];//背景色清空
    self.textAlignment          = NSTextAlignmentLeft;//文字左对齐
    self.returnKeyType          = UIReturnKeySend;//键盘return为发送
    self.keyboardAppearance     = UIKeyboardAppearanceDefault;//键盘外观默认
    self.keyboardType           = UIKeyboardTypeDefault;//键盘类型默认
    self.font                   = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];//字体类型
}

- (void)setFrame:(CGRect)frame
{
    if (self.frame.size.width != frame.size.width) {//如果当前view 的宽度不等于设置的宽度
        [self setNeedsDisplay];//调用绘图drawRect
    }
    [super setFrame:frame];
}
//TODO:设置页面
- (void)setCustomUI
{
    [self cutomUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self];//调用当textfield改变后通知
}
//TODO:通知回调
- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];//调用绘图drawRect
}

- (void)dealloc
{
    //移除通知，并且将placeHolder设置为nil
    _placeHolder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}
@end
