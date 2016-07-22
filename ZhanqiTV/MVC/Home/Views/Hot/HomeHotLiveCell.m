//
//  HotLiveCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeHotLiveCell.h"
#import "HomeListModel.h"
#import "HomeHotImageView.h"
@interface HomeHotLiveCell()
{
    BOOL isHotBatch;
    NSMutableArray *_hotArray;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@end
@implementation HomeHotLiveCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.scrollView];
    _hotArray = [[NSMutableArray alloc]init];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 95*kScreenFactor)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self.scrollView)+10, kScreen_width, 5)];
        line.backgroundColor = tableViewBackGroundColor;
        [self addSubview:line];
    }
    return _scrollView;
}
- (void)resetArray:(NSMutableArray *)array
{
    isHotBatch = YES;
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    if (_hotArray.count) {
        [_hotArray removeAllObjects];
    }
    CGFloat imageViewWidth = kScreen_width/2+5;
    self.scrollView.contentSize = CGSizeMake(5+array.count*(imageViewWidth+5), viewHeight(self.scrollView));
    for (int i = 0; i < array.count; i++) {
        HotLiveNumber *model = (HotLiveNumber *)array[i];
        [_hotArray addObject:model];
        HomeHotImageView *hotChildView = [[HomeHotImageView alloc]initWithFrame:CGRectMake(5+i*(imageViewWidth+5), 0, imageViewWidth, viewHeight(self.scrollView))];
        hotChildView.nickName = model.nickname;
        hotChildView.liveTitle = model.title;
        NSString *urlString;
        if (![model.spic isEqualToString:@""]) {//判断bpic有没图片地址，没有就用spic
            urlString = model.spic;
        }
        else
        {
            urlString = model.bpic;
        }
        hotChildView.imageName = urlString;
        hotChildView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotLiveAction:)];
        [hotChildView addGestureRecognizer:tap];
        [self.scrollView addSubview:hotChildView];
    }
}
- (void)resetModel:(HomeListModel *)model
{
    isHotBatch = NO;
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    if (_hotArray.count) {
        [_hotArray removeAllObjects];
    }
    CGFloat imageViewWidth = kScreen_width/2+5;
    self.scrollView.contentSize = CGSizeMake(5+model.lists.count*(imageViewWidth+5), viewHeight(self.scrollView));
    for (int i = 0; i < model.lists.count; i++) {
        List *list = (List *)model.lists[i];
        [_hotArray addObject:list];
        HomeHotImageView *hotChildView = [[HomeHotImageView alloc]initWithFrame:CGRectMake(5+i*(imageViewWidth+5), 0, imageViewWidth, viewHeight(self.scrollView))];
        hotChildView.nickName = list.nickname;
        hotChildView.liveTitle = list.title;
        NSString *urlString;
        if (![list.spic isEqualToString:@""]) {//判断bpic有没图片地址，没有就用spic
            urlString = list.spic;
        }
        else
        {
            urlString = list.bpic;
        }
        hotChildView.imageName = urlString;
        hotChildView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotLiveAction:)];
        [hotChildView addGestureRecognizer:tap];
        [self.scrollView addSubview:hotChildView];
    }
}
//TODO:热门直播跳转方法
- (void)hotLiveAction:(UITapGestureRecognizer *)tap
{
    LiveDetailViewController *vc = [[LiveDetailViewController alloc]init];
    if (isHotBatch == YES) {
        HotLiveNumber *model = (HotLiveNumber *)_hotArray[tap.view.tag];
        vc.videoId = model.videoId;
    }
    else
    {
        List *list = (List *)_hotArray[tap.view.tag];
        vc.videoId = list.videoId;
    }
    [_viewController.navigationController pushViewController:vc animated:YES];
}
@end
