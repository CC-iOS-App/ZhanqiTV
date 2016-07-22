//
//  HomeNavView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeNavView.h"
@interface HomeNavView()

@end
@implementation HomeNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonWidth = 24.0f;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_zhanqi"]];
        imageView.frame = CGRectMake(10, 25, 60, 29);
        imageView.backgroundColor = [UIColor blackColor];
        [self addSubview:imageView];
        
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(self.frame.size.width-(10+buttonWidth)*3, 30, buttonWidth, buttonWidth);
        [searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        searchButton.tag = 0;
        [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
//        [searchButton setTitle:@"搜" forState:UIControlStateNormal];
        
        [self addSubview:searchButton];
        
        UIButton *historicalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        historicalButton.frame = CGRectMake(self.frame.size.width-(10+buttonWidth)*2, CGRectGetMinY(searchButton.frame), buttonWidth, buttonWidth);
        [historicalButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        historicalButton.tag = 1;
        [historicalButton setImage:[UIImage imageNamed:@"nav_history"] forState:UIControlStateNormal];
//        [historicalButton setTitle:@"历" forState:UIControlStateNormal];
        [self addSubview:historicalButton];
        
        UIButton *kindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        kindButton.frame = CGRectMake(self.frame.size.width-10-buttonWidth, CGRectGetMinY(searchButton.frame), buttonWidth, buttonWidth);
        [kindButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        kindButton.tag = 2;
        [kindButton setImage:[UIImage imageNamed:@"nav_liveKind"] forState:UIControlStateNormal];
//        [kindButton setTitle:@"分" forState:UIControlStateNormal];
        [self addSubview:kindButton];
        
        self.backgroundColor = navigationBarColor;
    }
    return self;
}
- (void)buttonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectButton:)]) {
        [self.delegate didSelectButton:sender.tag];
    }
}
@end
