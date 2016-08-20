//
//  LiveDetailKindView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LiveDetailKindView.h"
#import "LiveDetailKindConfig.h"
#import "UIView+YZY.h"

@interface LiveDetailKindView()
{
    NSArray *_btnArray;
}

@end
@implementation LiveDetailKindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setButton];
    }
    return self;
}
#define ButtonBackgroundColor RGB(30,35,39)
- (void)setButton
{
    _btnArray = [LiveDetailKindConfig detailItem];
    
    CGFloat buttonWidth = self.width / _btnArray.count;
    [_btnArray enumerateObjectsUsingBlock:^(LiveDetailKindItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = item.tag;
        btn.exclusiveTouch = YES;
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setImage:item.normalImage forState:UIControlStateNormal];
        [btn setImage:item.highlightedImage forState:UIControlStateHighlighted];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        [btn setTitleColor:navigationBarColor forState:UIControlStateSelected];
        [btn setTitleColor:navigationBarColor forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(item.tag * buttonWidth, 0, buttonWidth, self.height)];
        btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [btn setBackgroundColor:ButtonBackgroundColor];
        if (item.tag == 1) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor blackColor];
        }
        [self addSubview:btn];
    }];
}
- (void)onTouchButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button != btn) {
                button.selected = NO;
                [button setBackgroundColor:ButtonBackgroundColor];
            }
            else
            {
                button.selected = YES;
                [button setBackgroundColor:[UIColor blackColor]];
            }
        }
    }
    NSInteger tag = [btn tag];
    
    for (LiveDetailKindItem *item in _btnArray) {
        if (item.tag == tag) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(onTouchDetailKind:item:)]) {
                [self.delegate onTouchDetailKind:self item:item];
            }
            break;
        }
        
    }
}
@end
