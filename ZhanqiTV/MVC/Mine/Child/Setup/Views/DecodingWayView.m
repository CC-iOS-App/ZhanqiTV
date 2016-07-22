//
//  DecodingWayView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "DecodingWayView.h"
@interface DecodingWayView()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *buttonView;
@end
@implementation DecodingWayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *buttonArray = @[@"软解",@"硬解",@"取消"];
        CGFloat buttonHeight = 44.0f;
        [self addSubview:self.backGroundView];
        [self addSubview:self.buttonView];
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setTitle:buttonArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button setBackgroundColor:[UIColor whiteColor]];
            
            UIView *lineView = [[UIView alloc]init];
            if (i == 0) {
                button.frame = CGRectMake(0, 0, self.buttonView.frame.size.width, buttonHeight);
                lineView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), button.frame.size.width, 0.5);
            }
            else if (i == 1)
            {
                button.frame = CGRectMake(0, buttonHeight+0.5, self.buttonView.frame.size.width, buttonHeight);
                lineView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), button.frame.size.width,10);
            }
            else
            {
                button.frame = CGRectMake(0, buttonHeight*2+10+0.5, self.buttonView.frame.size.width, buttonHeight);
                lineView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), button.frame.size.width, 0);
            }
            button.tag = i;
            [button addTarget:self action:@selector(selectedMyButton:) forControlEvents:UIControlEventTouchUpInside];
            lineView.backgroundColor = tableViewBackGroundColor;
            [self.buttonView addSubview:lineView];
            [self.buttonView addSubview:button];
        }
    }
    return self;
}
- (UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 44*3+0.5+10)];
        
    }
    return _buttonView;
}
- (UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelfView:)];
        [_backGroundView addGestureRecognizer:tap];
        _backGroundView.alpha = 0.0f;
    }
    return _backGroundView;
}
- (void)selectedMyButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedDecodingWayButton:withString:)]) {
        [self.delegate didSelectedDecodingWayButton:sender.tag withString:sender.titleLabel.text];
    }
}
- (void)hideSelfView:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideDecodingWayView)]) {
        [self.delegate hideDecodingWayView];
    }
}
- (void)appearView
{
    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.buttonView.frame = CGRectMake(0, self.frame.size.height-self.buttonView.frame.size.height, self.buttonView.frame.size.width, self.buttonView.frame.size.height);
        self.backGroundView.alpha = 0.7;
    }];
    [UIView commitAnimations];
}
- (void)hideView
{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.buttonView.frame = CGRectMake(0, self.frame.size.height, self.buttonView.frame.size.width, self.buttonView.frame.size.height);
        self.backGroundView.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
        
    }];
    [UIView commitAnimations];
}
@end
