//
//  InputToolBar.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputToolBar.h"
#import "InputBarItemType.h"
#import "InputTextFiled.h"
#import "UIImage+YZY.h"
#import "UIView+YZY.h"
@interface InputToolBar()

@property (nonatomic, copy) NSArray<NSNumber *> *types;

@property (nonatomic, copy) NSDictionary *dict;

@end
@implementation InputToolBar

//TODO:初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:[UIImage fetchImage:@"btn_face"] forState:UIControlStateNormal];
        [_emoticonBtn sizeToFit];
        
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage fetchImage:@"btn_gift"] forState:UIControlStateNormal];
        [_giftBtn sizeToFit];
        
        _moreMediaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreMediaBtn setImage:[UIImage fetchImage:@"btn_more"] forState:UIControlStateNormal];
        [_moreMediaBtn sizeToFit];
        
        _emoticonAndTextBackGroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _emoticonAndTextBackGroundView.backgroundColor = tableViewBackGroundColor;
        _emoticonAndTextBackGroundView.layer.cornerRadius = 5.f;
        
        _inputTextFiled = [[InputTextFiled alloc]initWithFrame:CGRectZero];
        
        //设置toolbar上可交互类型
        self.types = @[
                            @(InputBarItemTypeEmoticon),
                            @(InputBarItemTypeText),
                            @(InputBarItemTypeGift),
                            @(InputBarItemTypeMore)
                       ];
    }
    return self;
}

- (void)setInputBarItemTypes:(NSArray<NSNumber *> *)types
{
    self.types = types;
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 46.f;
    return CGSizeMake(size.width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.types containsObject:@(InputBarItemTypeText)]) {//如果交互控件当中有text类型
        //先把文本输入框的宽度计算出来
        [self resetInputTextFiled];
    }
    
    CGFloat left = 0;
    
    //设置子视图的坐标，并且添加到父视图
    for (NSNumber *type in self.types) {
        UIView *view = [self subViewForType:type.integerValue];
        [self addSubview:view];
        view.left = left + self.spacing;
        view.centerY = self.height * .5f;//设置中心点
        left = view.right;
    }
    
    [self adjustTextAndRecordView];
    
}

- (void)resetInputTextFiled{
    //先把输入框的父视图宽度设置为0，然后在返回的视图宽度相加后，会得到除了输入框的父视图以外的所有视图宽度和
    self.emoticonAndTextBackGroundView.width = 0;
    CGFloat width = 0;
    for (NSNumber *type in self.types) {
        UIView *view = [self subViewForType:type.integerValue];
        width += view.width;
    }
//    然后拿到所有视图的宽度和以后加上间隔
    width += self.spacing * (self.types.count + 1);
//    width += self.spacing * (_showGiftBtn ? (self.types.count + 1) : self.types.count);
    //输入框的父视图的宽度就是以下
    self.emoticonAndTextBackGroundView.width = self.width - width;
    self.emoticonAndTextBackGroundView.height = self.height - self.spacing * 2;//输入框父视图高度
}

- (void)adjustTextAndRecordView{
    if (self.emoticonAndTextBackGroundView.superview) {//如果添加表情按钮和输入框的视图有父视图
        CGFloat textViewMargin   = 2.f;
        
        self.emoticonBtn.frame = CGRectInset(self.emoticonAndTextBackGroundView.frame, textViewMargin, textViewMargin);//将emoticonAndTextBackGroundView的坐标按照textViewMargin进行位移
        self.emoticonBtn.width = self.moreMediaBtn.width;
        [self addSubview:self.emoticonBtn];
        //输入框
        self.inputTextFiled.frame = CGRectInset(self.emoticonAndTextBackGroundView.frame, self.emoticonBtn.right, textViewMargin);
        [self addSubview:self.inputTextFiled];
    }
}

- (UIView *)subViewForType:(InputBarItemType)type
{
    if (!_dict) {
        _dict = @{
                  @(InputBarItemTypeText) : self.emoticonAndTextBackGroundView,
                  @(InputBarItemTypeGift) : self.giftBtn,
                  @(InputBarItemTypeMore) : self.moreMediaBtn
                  };
    }
    return _dict[@(type)];
}

- (CGFloat)spacing{
    return 6.f;
}
@end
