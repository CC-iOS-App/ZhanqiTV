//
//  InputMoreContainerView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputMoreContainerView.h"
#import "MediaItem.h"
#import "UIView+YZY.h"
#import "InputPageView.h"
NSInteger MaxItemCountInPage = 8;
NSInteger ButtonItemWidth   = 51;
NSInteger ButtonItemHeight  = 72;//48
NSInteger PageRowCount      = 2;
NSInteger PageColumnCount   = 4;
NSInteger ButtonBegintLeftX = 20;

@interface InputMoreContainerView()<InputPageViewDataSource,InputPageViewDelegate>
{
    NSArray         *_mediaButtons;
    NSArray         *_mediaItems;
    InputPageView   *_pageView;
}
@end
@implementation InputMoreContainerView

- (void)setConfig:(id<SessionCofig>)config
{
    _config = config;
    [self genMediaButtons];
}
- (void)genMediaButtons
{
    NSMutableArray *mediaButtons = [NSMutableArray array];
    NSMutableArray *mediaItems = [NSMutableArray array];
    
    if (self.config && [self.config respondsToSelector:@selector(mediaItems)]) {
        NSArray *items = [self.config mediaItems];
        [items enumerateObjectsUsingBlock:^(MediaItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL shouldHidden = NO;
            if (self.config && [self.config respondsToSelector:@selector(shouldHideItem:)]) {
                shouldHidden = [self.config shouldHideItem:item];
            }
            if (!shouldHidden) {
                [mediaItems addObject:item];
                UIButton *btn = [[UIButton alloc]init];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setImage:item.normalImage forState:UIControlStateNormal];
                [btn setImage:item.selectedImage forState:UIControlStateHighlighted];
                [btn setTitle:item.title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                [btn setImageEdgeInsets:UIEdgeInsetsMake(- 50, 0, 0, 0)];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(76, -72, 0, 0)];
                [btn.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]];
                btn.tag = item.tag;
                [mediaButtons addObject:btn];
            }
        }];
    }
    _mediaButtons = mediaButtons;
    _mediaItems = mediaItems;
    
    _pageView = [[InputPageView alloc]initWithFrame:self.bounds];
    _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageView.dataSource = self;
    [self addSubview:_pageView];
    [_pageView scrollToPage:0];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat originalWidth = self.frame.size.width;
    if (originalWidth != frame.size.width) {
        [_pageView reloadData];
    }
}
- (void)dealloc
{
    _pageView.dataSource = nil;
}

#pragma mark - PageViewDataSource

- (NSInteger)numberOfPages:(InputPageView *)pageView
{
    NSInteger count = _mediaButtons.count / MaxItemCountInPage ;
    
    count = _mediaButtons.count % MaxItemCountInPage == 0 ? count : count + 1;
    return MAX(count, 1);
}

- (UIView *)mediaPageView:(InputPageView *)pageView beginItem:(NSInteger)begin endItem:(NSInteger)end
{
    UIView *subView = [[UIView alloc]init];
    NSInteger span = (self.width - PageColumnCount * ButtonItemWidth) / (PageColumnCount + 1);//各个按钮之间的间距
    CGFloat startY      = ButtonBegintLeftX;
    NSInteger coloumnIndex = 0;
    NSInteger rowIndex = 0;
    NSInteger indexInPage = 0;
    for (NSInteger index = begin; index < end; index++) {
        id obj = _mediaButtons[index];
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //计算位置
            rowIndex    = indexInPage / PageColumnCount;
            coloumnIndex= indexInPage % PageColumnCount;
            CGFloat x = span + (ButtonItemWidth + span) *coloumnIndex;
            CGFloat y = 0.f;
            if (rowIndex > 0) {
                y = rowIndex * ButtonItemHeight + startY + 15;
            }
            else
            {
                y = rowIndex * ButtonItemHeight + startY;
            }
            [button setFrame:CGRectMake(x, y, ButtonItemWidth, ButtonItemHeight)];
            [subView addSubview:button];
            indexInPage ++;
        }
    }
    return subView;
}

- (UIView *)oneLineMediaInPageView:(InputPageView *)pageView
                    viewInPage:(NSInteger)index
                         count:(NSInteger)count
{
    UIView *subView = [[UIView alloc]init];
    NSInteger span = (self.width - count * ButtonItemWidth) / (count + 1);
    
    for (NSInteger btnIndex = 0; btnIndex < count; btnIndex++) {
        id obj = _mediaButtons[btnIndex];
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
            CGRect iconRect = CGRectMake(span + (ButtonItemWidth + span) * btnIndex, 58, ButtonItemWidth, ButtonItemHeight);
            [button setFrame:iconRect];
            [subView addSubview:button];
        }
    }
    return subView;
}

- (UIView *)pageView:(InputPageView *)pageView viewInPage:(NSInteger)index
{
    if (_mediaButtons.count == 2 || _mediaButtons.count == 3) {//一行显示2个或者3个
        return [self oneLineMediaInPageView:pageView viewInPage:index count:_mediaButtons.count];
    }
    if (index < 0) {
        assert(0);
        index = 0;
    }
    NSInteger begin = index * MaxItemCountInPage;
    NSInteger end = (index + 1) * MaxItemCountInPage;
    if (end > _mediaButtons.count) {
        end = _mediaButtons.count;
    }
    return [self mediaPageView:pageView beginItem:begin endItem:end];
}
- (void)onTouchButton:(id)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    
    for (MediaItem *item in _mediaItems) {
        if (item.tag == tag) {
            if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(onTapMediaItem:)]) {
                [_actionDelegate onTapMediaItem:item];
            }
            break;
        }
    }
}
@end
