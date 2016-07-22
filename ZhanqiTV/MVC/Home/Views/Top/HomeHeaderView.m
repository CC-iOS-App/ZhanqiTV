//
//  HomeHeaderView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/12.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeHeaderView.h"
@interface HomeHeaderView()<UIScrollViewDelegate>
{
    dispatch_source_t _timer;   //两次网络请求间隔定时器
    ShufflingSuperRoomModel *_superRoomModel;
    NSInteger arrayCount;
    NSInteger pageControlPage;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleBackgroundView;
@end
@implementation HomeHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setShuffling
{
    NSTimeInterval period = 4.0;//设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{//执行事件
        if (pageControlPage == arrayCount) {
            pageControlPage = 0;
        }
        [UIView beginAnimations:nil context:nil];
        
        [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(pageControlPage*viewWidth(self.scrollView), self.scrollView.contentOffset.y);
        }];
        [UIView commitAnimations];
        NSLog(@"contentOffset.x == %f",self.scrollView.contentOffset.x);
        pageControlPage++;
    });
    dispatch_resume(_timer);
}
- (void)setup
{
    pageControlPage = 0;
    [self addSubview:self.scrollView];
    [self addSubview:self.titleBackgroundView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.pageControl];
    [self.pageControl bringSubviewToFront:self];
//    [self setShuffling];
    
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, viewY(self.titleBackgroundView), viewWidth(self)/4*3, 20)];
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIView *)titleBackgroundView
{
    if (!_titleBackgroundView) {
        _titleBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self)-20, viewWidth(self), 20)];
        _titleBackgroundView.backgroundColor = [UIColor blackColor];
        _titleBackgroundView.alpha = 0.5;
    }
    return _titleBackgroundView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}
//设置数据
- (void)resetModel:(ShufflingSuperRoomModel *)model
{
//    static BOOL haveData = YES;
    _superRoomModel = model;
    arrayCount = model.data.count;
    self.pageControl.numberOfPages = model.data.count;//设置页数
    self.pageControl.frame = CGRectMake(kScreen_width-10*model.data.count-20, viewHeight(self.scrollView)-20, 10*model.data.count, 15);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame)*model.data.count, CGRectGetHeight(self.scrollView.frame));//设置滑动视图可滑动大小
    
    for (int i = 0; i < model.data.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        ShufflingRoomModel *roomModel = (ShufflingRoomModel *)model.data[i];
        if (i == 0) {
            self.titleLabel.text = roomModel.title;
        }
        NSString *urlString;
        if (![roomModel.spic isEqualToString:@""]) {
            urlString = roomModel.spic;
        }
        else
        {
            urlString = roomModel.bpic;
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"default_image"]];
        //加入手势动作
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liveDetailAction:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
    }
    [self.pageControl bringSubviewToFront:self];
//    if (haveData == YES) {
//        [self setShuffling];
//        haveData = NO;
//    }
}
- (void)liveDetailAction:(UITapGestureRecognizer *)tap
{
    LiveDetailViewController *vc = [[LiveDetailViewController alloc]init];
    ShufflingRoomModel *roomModel = (ShufflingRoomModel *)_superRoomModel.data[tap.view.tag];
    vc.videoId = roomModel.room.videoId;
    [_viewController.navigationController pushViewController:vc animated:YES];
}
//TODO:UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    pageControlPage = page;
    self.titleLabel.text = ((ShufflingRoomModel *)_superRoomModel.data[page]).title;

    self.pageControl.currentPage = page;
    [self.pageControl updateCurrentPageDisplay];
}
@end
