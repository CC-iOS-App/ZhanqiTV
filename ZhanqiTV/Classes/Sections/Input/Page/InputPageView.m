//
//  InputPageView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputPageView.h"

@interface InputPageView()
{
    NSInteger _currentPage;
    NSInteger _currentPageForRotation;
}

@property (nonatomic, strong) NSMutableArray *pages;

- (void)setupControls;

//重新载入的流程
- (void)calculatePageNumbers;//计算page页数
- (void)reloadPage;//刷新数据
- (void)raisePageIndexChangedDelegate;//调用滑动结束后代理（包括总页数的）
@end
@implementation InputPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupControls];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat originalWidth = self.frame.size.width;
    //当设置frame与原有不相等时，刷新data
    if (originalWidth != frame.size.width) {
        [self reloadData];
    }
}
- (void)dealloc
{
    _scrollView.delegate = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_scrollView setFrame:self.bounds];
    CGSize size = self.bounds.size;
    
    //设置可滑动大小
    [self.scrollView setContentSize:CGSizeMake(size.width * self.pages.count, size.height)];
    
    for (NSInteger i = 0 ; i < self.pages.count; i++) {
        id obj = self.pages[i];
        
        //设置子视图位置
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView *)obj setFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
        }
    }
    
    
    BOOL animation = NO;
    if (self.pageViewDelegate && [self.pageViewDelegate respondsToSelector:@selector(needScrollAnimation)]) {
        animation = [self.pageViewDelegate needScrollAnimation];//返回是否动画滑动
    }
    //滑动视图滑动到指定当前位置
    [self.scrollView scrollRectToVisible:CGRectMake(_currentPage * size.width, 0, size.width, size.height) animated:animation];
}

//TODO:初始化滑动视图
- (void)setupControls
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
    }
}

#pragma mark - 对外接口

//滑动到指定视图
- (void)scrollToPage:(NSInteger)page
{
    if (_currentPage != page || page == 0) {
        _currentPage = page;
        [self reloadData];
    }
}

- (void)reloadData
{
    [self calculatePageNumbers];
    [self reloadPage];
}

- (UIView *)viewAtIndex:(NSInteger)index//返回指定view
{
    UIView *view = nil;
    if (index >= 0 && index < _pages.count) {
        id obj = _pages[index];
        if ([obj isKindOfClass:[UIView class]]) {
//            view = (UIView *)obj;
            view = obj;
        }
    }
    return view;
}
- (NSInteger)currentPage//返回当前选中page
{
    return _currentPage;
}

//安全处理，以免最大值小于最小值或者最小值大于最大值
- (NSInteger)pageInBound:(NSInteger)value min:(NSInteger)min max:(NSInteger)max{
    if (max < min) {
        max = min;
    }
    NSInteger bounded = value;
    if (bounded > max) {
        bounded = max;
    }
    if (bounded < min) {
        bounded = min;
    }
    return bounded;
}

#pragma mark - Page载入和销毁
//防止加载太多的view占用大量内存
- (void)loadPagesForCurrentPage:(NSInteger)currentPage
{
    NSUInteger count = _pages.count;
    if (count == 0) {
        return;
    }
    
    //这里设置起始为当前页的上一页，
    NSInteger first = [self pageInBound:currentPage - 1 min:0 max:count - 1];
    //设置结束为当前页的下一页
    NSInteger last  = [self pageInBound:currentPage + 1 min:0 max:count - 1];
    
    //主要是加载3张view，上一页，当前页，下一页
    NSRange range = NSMakeRange(first, last - first + 1);
    
    for (NSUInteger index = 0; index < count; index++) {
        //如果index在range范围内
        if (NSLocationInRange(index, range)) {
            id obj = _pages[index];
            //如果指定obj不为uiview，可能是占位符了，那就重新设置这张页面，其它不作处理
            if (![obj isKindOfClass:[UIView class]]) {
                if (_dataSource && [_dataSource respondsToSelector:@selector(pageView:viewInPage:)]) {
                    //从数据源获取指定view
                    UIView *view = [_dataSource pageView:self viewInPage:index];
                    //将指定的index位置处的占位符改为view
                    [_pages replaceObjectAtIndex:index withObject:view];
                    [self.scrollView addSubview:view];
                    
                    //设置view坐标大小
                    CGSize size = self.bounds.size;
                    [view setFrame:CGRectMake(size.width * index, 0, size.width, size.height)];
                }
                else
                {
                    assert(0);// 如果条件返回错误，终止程序
                }
            }
        }
        else//否则移除该视图，在数组中用占位符取代位置
        {
            id obj = _pages[index];
            if ([obj isKindOfClass:[UIView class]]) {
                [obj removeFromSuperview];
                [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
            }
        }
    }
}

- (void)calculatePageNumbers
{
    NSInteger numberOfPages = 0;
    //清空已有view
    for (id obj in _pages) {
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView *)obj removeFromSuperview];
        }
    }
    
    //从代理方法返回总页数
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPages:)]) {
        numberOfPages = [_dataSource numberOfPages:self];
    }
    //设置数组容量
    self.pages = [NSMutableArray arrayWithCapacity:numberOfPages];
    
    //往数组存放占位符
    for (NSInteger i = 0; i < numberOfPages; i++) {
        [_pages addObject:[NSNull null]];
    }
    //注意，这里设置delegate是因为计算contentsize的时候会引起scrollViewDidScroll执行，修改currentpage的值，这样在贴图（举个例子）前面的分类页数比后面的分类页数多，前面的分类滚动到最后面一页后，再显示后面的分类，会显示不正确
    self.scrollView.delegate = nil;
    CGSize size = self.bounds.size;
    [self.scrollView setContentSize:CGSizeMake(size.width * numberOfPages, size.height)];//如果已经有代理，会可能改变currentpage值，上面已经提到
    self.scrollView.delegate = self;//重新设置代理
}

- (void)reloadPage
{
    //reload的时候尽量记住上次的位置
    if (_currentPage >= [_pages count]) {
        _currentPage = [_pages count] - 1;
    }
    if (_currentPage < 0) {
        _currentPage = 0;
    }
    
    [self loadPagesForCurrentPage:_currentPage];
    [self raisePageIndexChangedDelegate];
    [self setNeedsLayout];//调用layoutSubViews
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.bounds.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;//滑动视图滑动距离
    NSInteger page = (NSInteger)(fabs(offsetX / width));//fabs()函数实型数据求绝对值
    
    //如果_currentPage与所滑动地方page相等不做任何处理，否则对page进行重新载入处理
    if (page >= 0 && page < [_pages count]) {
        if (_currentPage == page) {
            return;
        }
        _currentPage = page;
        [self loadPagesForCurrentPage:_currentPage];
    }
    //调用滑动结束后代理（不包括总页数的）
    if (_pageViewDelegate && [_pageViewDelegate respondsToSelector:@selector(pageViewDidScroll:)]) {
        [_pageViewDelegate pageViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //当滑动视图结束滑动减速时
    [self raisePageIndexChangedDelegate];
}

#pragma mark - 辅助方法
- (void)raisePageIndexChangedDelegate
{
    //调用滑动结束后代理（包括总页数的）
    if (_pageViewDelegate && [_pageViewDelegate respondsToSelector:@selector(pageViewScrollEnd:currentIndex:totolPages:)]) {
        [_pageViewDelegate pageViewScrollEnd:self currentIndex:_currentPage totolPages:[_pages count]];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _scrollView.delegate = nil;
    _currentPageForRotation = _currentPage;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize size = self.bounds.size;
    _scrollView.contentSize = CGSizeMake(size.width * [_pages count], size.height);
    for (NSUInteger i = 0 ; i < [_pages count]; i++) {
        id obj = _pages[i];
        if ([obj isKindOfClass:[UIView class]]) {
            [(UIView *)obj setFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
            /*
             //这里有点ugly,先这样吧...
             if ([obj respondsToSelector:@selector(reset)])
             {
             [obj performSelector:@selector(reset)];
             }*/
        }
    }
    _scrollView.contentOffset = CGPointMake(_currentPageForRotation * size.width, 0);
    _scrollView.delegate = self;
}
@end
