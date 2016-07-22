//
//  EntertainmentTopCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "EntertainmentTopCell.h"
#import "EntertainmentTopCustomView.h"

@interface EntertainmentTopCell()
@property (nonatomic, strong)UIScrollView *scrollView;
@end
@implementation EntertainmentTopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
}
//加载数据
- (void)resetModel:(EntertainmentHotModel *)model
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.scrollView.contentSize = CGSizeMake(model.banner.count*viewWidth(self.scrollView), viewHeight(self.scrollView));
    
    CGFloat viewWidth = viewWidth(self.scrollView)/4;
    for (int i = 0; i < model.banner.count; i++) {
        
        EntertainmentBanner *banner = (EntertainmentBanner *)model.banner[i];
        EntertainmentTopCustomView *customeView = [[EntertainmentTopCustomView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, viewHeight(self.scrollView))];
        customeView.nickName = banner.nickname;
        NSString *urlString;
        if (![banner.spic isEqualToString:@""]) {//判断spic有没图片地址，没有就用bpic
            urlString = banner.spic;
        }
        else
        {
            urlString = banner.bpic;
        }
        customeView.imageName = urlString;
        [self.scrollView addSubview:customeView];
    }
}
//懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 97*kScreenFactor)];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
