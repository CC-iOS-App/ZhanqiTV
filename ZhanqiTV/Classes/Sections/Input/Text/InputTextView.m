//
//  InputTextView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
- (void)customUI
{
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.backgroundColor = [UIColor clearColor];
    self.keyboardType = UIKeyboardTypeDefault;
    self.textAlignment = NSTextAlignmentLeft;
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.returnKeyType = UIReturnKeySend;
}
- (void)setFrame:(CGRect)frame
{
    if (self.frame.size.width != frame.size.width) {
        [self setNeedsDisplay];
    }
    [super setFrame:frame];
}
- (void)setCustomUI
{
    [self customUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.f, 7.f, rect.size.width, rect.size.height);
        //设置段落样式
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略，显示头的文字内容
        [self.placeHolder drawInRect:placeHolderRect withAttributes:@{NSFontAttributeName : self.font,NSForegroundColorAttributeName : [UIColor lightGrayColor],NSParagraphStyleAttributeName : paragraphStyle}];
    }
}
- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)dealloc
{
    _placeHolder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
@end
