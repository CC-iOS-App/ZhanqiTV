//
//  OfficialAnnouncementView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/1.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "OfficialAnnouncementView.h"
@interface OfficialAnnouncementView()

@end
@implementation OfficialAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {

        CGFloat buttonWidth = frame.size.width/array.count;
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (i == 0) {
                button.selected = YES;
            }
            button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, frame.size.height);
            [button setTitle:array[i] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
            
            [button setTitleColor:navigationBarColor forState:UIControlStateSelected];
            
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            button.tag = i;
            
            [button addTarget:self action:@selector(didSelectAnnouncementAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self)-0.5, kScreen_width, 0.5)];
        
        line.backgroundColor = navigationBarColor;
        
        self.backgroundColor = tableViewBackGroundColor;
        
        [self addSubview:line];
    }
    return self;
}
- (void)didSelectedButton:(NSInteger)index
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == index) {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
    }
}
- (void)didSelectAnnouncementAction:(UIButton *)sender
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == sender.tag) {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAnnouncementButton:)]) {
        [self.delegate didSelectAnnouncementButton:sender.tag];
    }
}
@end
