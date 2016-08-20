    //
//  InputEmoticonContainerView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/5.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputEmoticonContainerView.h"
#import "InputEmoticonTableView.h"
#import "InputPageView.h"
#import "InputEmoticonButton.h"
#import "UIView+YZY.h"
#import "InputEmoticonManager.h"
#import "InputEmoticonDefine.h"
#import "UIImage+YZY.h"
NSInteger CustomPageControlHeight = 36;
NSInteger CustomPageViewHeight    = 159;

@interface InputEmoticonContainerView()<InputEmoticonTableDelegate,EmoticonButtonTouchDelegate>
@property (nonatomic, strong) NSMutableArray *pageData;
@end
@implementation InputEmoticonContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
    }
    return self;
}

- (void)loadConfig
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setConfig:(id<SessionCofig>)config
{
    _config = config;
    [self loadUIComponents];
}

//初始化UI
- (void)loadUIComponents
{
    _emoticonPageView                   = [[InputPageView alloc]initWithFrame:self.bounds];
    _emoticonPageView.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
    _emoticonPageView.height = CustomPageViewHeight;
    _emoticonPageView.backgroundColor   = [UIColor clearColor];
    _emoticonPageView.dataSource        = self;
    _emoticonPageView.pageViewDelegate  = self;
    [self addSubview:_emoticonPageView];//emoji表情自定义pageview
    
    //pagecontrol
    _emotPageController                     = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, self.width, CustomPageControlHeight)];
    _emotPageController.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
    _emotPageController.currentPageIndicatorTintColor = [UIColor grayColor];//当前页颜色
    _emotPageController.pageIndicatorTintColor = [UIColor lightGrayColor];//其它页颜色
    [_emotPageController setUserInteractionEnabled:NO];//关闭交互
    [self addSubview:_emotPageController];
    
    NSArray *catalogs = [self reloadData];
    
    //底部表情类型选择按钮
    _tabView = [[InputEmoticonTableView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0) catalogs:catalogs];
    _tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabView.delegate = self;
    [_tabView.sendButton addTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tabView];
    
    if (_currentCatalogData.pagesCount > 0) {//初始化pageview中的数据
        _emotPageController.numberOfPages = [_currentCatalogData pagesCount];
        _emotPageController.currentPage = 0;
//        [_emoticonPageView scrollToPage:0];//滑动到第一页   
    }
}

- (void)setFrame:(CGRect)frame
{
    CGFloat originalWidth = self.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        //加载表情数据
        self.tabView.emoticonCatalogs = [self reloadData];
    }
}

- (NSArray *)reloadData
{
    InputEmoticonCatalog *defaultCatalog = [self loadDefaultCatalog];//返回emoji表情组
    BOOL disableCharlet = NO;
    if ([self.config respondsToSelector:@selector(disableCharlet)]) {
        disableCharlet = [self.config disableCharlet];
    }
    NSArray *charlets = disableCharlet ? nil : [self loadChartlet];

    NSArray *catalogs = defaultCatalog ? [@[defaultCatalog] arrayByAddingObjectsFromArray:charlets] : charlets;
    
    
    self.currentCatalogData = catalogs.firstObject;//默认第一组表情类型

    return catalogs;
}

#define EmoticonPageControllerMarginButtom 10
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.emotPageController.top = self.emoticonPageView.bottom - EmoticonPageControllerMarginButtom;
    self.tabView.bottom = self.height;
}

#pragma mark - config data

- (NSInteger)sumPages//返回所有表情总页数
{
    __block NSInteger pagesCount;
    
    [self.tabView.emoticonCatalogs enumerateObjectsUsingBlock:^(InputEmoticonCatalog *data, NSUInteger idx, BOOL * _Nonnull stop) {
        pagesCount += data.pagesCount;
    }];
    return pagesCount;
}


- (UIView *)emojPageView:(InputPageView *)pageView inEmoticonCatalog:(InputEmoticonCatalog *)emoticon page:(NSInteger)page
{
    UIView *subView = [[UIView alloc]init];
    NSInteger iconHeight = emoticon.layout.imageHeight;
    NSInteger iconWidth  = emoticon.layout.imageWidth;
    CGFloat startX       = (emoticon.layout.cellWidth - iconWidth) / 2 + EmojiLeftMargin;
    CGFloat startY       = (emoticon.layout.cellHeight - iconHeight) / 2 + EmojiTopMargin;
    int32_t coloumnIndex = 0;
    int32_t rowIndex = 0;
    int32_t indexInPage = 0;
    NSInteger begin = page * emoticon.layout.itemCountInPage;//从哪里开始
    NSInteger end   = begin + emoticon.layout.itemCountInPage;
    end = end > emoticon.emoticons.count ? emoticon.emoticons.count : end;//end 是否有超出表情数组中元素个数
    for (NSInteger index = begin; index < end; index++) {
        InputEmoticon *data = [emoticon.emoticons objectAtIndex:index];
        InputEmoticonButton *button = [InputEmoticonButton iconButtonWithData:data catalogID:emoticon.catalogID delegate:self];
        //计算表情位置
        rowIndex        = indexInPage / emoticon.layout.columes;
        coloumnIndex    = indexInPage % emoticon.layout.columes;
        CGFloat x       = coloumnIndex * emoticon.layout.cellWidth + startX;
        CGFloat y       = rowIndex * emoticon.layout.cellHeight + startY;
        CGRect iconRect = CGRectMake(x, y, iconWidth, iconHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
        indexInPage++;
    }
    if (coloumnIndex == emoticon.layout.columes - 1) {//这里没明白
        rowIndex = rowIndex + 1;
        coloumnIndex = -1;//设置成－1是因为显示在第0位，有加1
    }
    if ([emoticon.catalogID isEqualToString:EmojiCatalog]) {
        [self addDeleteEmoticonButtonToView:subView ColumnIndex:coloumnIndex RowIndex:rowIndex StartX:startX Starty:startY IconWidth:iconWidth IconHeight:iconHeight InEmoticonCatalog:emoticon];
    }
    
    return subView;
}

//在emoji右下角添加一个删除按钮，如果没有满一页，在最后一个地方添加
- (void)addDeleteEmoticonButtonToView:(UIView *)view
                          ColumnIndex:(NSInteger)coloumnIndex
                             RowIndex:(NSInteger)rowIndex
                               StartX:(CGFloat)startX
                               Starty:(CGFloat)startY
                            IconWidth:(CGFloat)iconWidth
                           IconHeight:(CGFloat)iconHeight
                    InEmoticonCatalog:(InputEmoticonCatalog *)emoticon
{
    InputEmoticonButton *deleteIcon = [[InputEmoticonButton alloc]init];
    deleteIcon.delegate = self;
    deleteIcon.userInteractionEnabled = YES;
    deleteIcon.exclusiveTouch = YES;
    deleteIcon.contentMode = UIViewContentModeCenter;
    NSString *prefix = [EmoticonPath stringByAppendingPathComponent:EmojiPath];
    
    NSString *imageNomalName = [prefix stringByAppendingPathComponent:@"emoji_del_normal"];
    NSString *imagePressName = [prefix stringByAppendingPathComponent:@"emoji_del_pressed"];
    UIImage *imageNoaml = [UIImage imageInKit:imageNomalName];
    UIImage *imagePress = [UIImage imageInKit:imagePressName];
    [deleteIcon setImage:imageNoaml forState:UIControlStateNormal];
    [deleteIcon setImage:imagePress forState:UIControlStateHighlighted];
    [deleteIcon addTarget:deleteIcon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat newX = (coloumnIndex + 1) * emoticon.layout.cellWidth + startX;
    CGFloat newY = rowIndex * emoticon.layout.cellHeight + startY;
    CGRect deleteIconRect = CGRectMake(newX, newY, DeleteIconWidth, DeleteIconHeight);
    [deleteIcon setFrame:deleteIconRect];
    [view addSubview:deleteIcon];
}

#pragma mark - pageViewDelegate
- (NSInteger)numberOfPages:(InputPageView *)pageView
{
    return [self sumPages];//返回所需pageview个数
}

- (UIView *)pageView:(InputPageView *)pageView viewInPage:(NSInteger)index
{
    NSInteger page = 0;
    
    InputEmoticonCatalog *emoticon;
    for (emoticon in self.tabView.emoticonCatalogs) {//找出index所在的emticon数组
        NSInteger newPage = page + emoticon.pagesCount;
        if (newPage > index) {
            break;
        }
        page = newPage;
    }
    return [self emojPageView:pageView inEmoticonCatalog:emoticon page:index - page];//根据所在数组以及所在数组第几页（index － page）返回该view
}
//加载emoji表情
- (InputEmoticonCatalog *)loadDefaultCatalog
{
    InputEmoticonCatalog *emoticonCatalog = [[InputEmoticonManager sharedManager] emoticonCatalog:EmojiCatalog];
    if (emoticonCatalog) {
        InputEmoticonLayout *layout = [[InputEmoticonLayout alloc]initEmojiLayout:self.width];
        emoticonCatalog.layout = layout;
        emoticonCatalog.pagesCount = [self numberOfPagesWithEmoticon:emoticonCatalog];
    }
    return emoticonCatalog;
}

- (NSArray *)loadChartlet
{
    NSArray *chatlets = [[InputEmoticonManager sharedManager] loadChartletEmoticonCatalog];
    
    for (InputEmoticonCatalog *item in chatlets) {
        InputEmoticonLayout *layout = [[InputEmoticonLayout alloc]initCharletLayout:self.width];
        item.layout = layout;
        item.pagesCount = [self numberOfPagesWithEmoticon:item];
    }
    return chatlets;
}
//找到某组表情的起始位置
- (NSInteger)pageIndexWithEmoticon:(InputEmoticonCatalog *)emoticonCatalog{
    NSInteger pageIndex = 0;
    for (InputEmoticonCatalog *emoticon in self.tabView.emoticonCatalogs) {
        if (emoticon == emoticonCatalog) {
            break;
        }
        pageIndex += emoticon.pagesCount;
    }
    return pageIndex;
}

//返回指定index在其所在emoticon中第几页
- (NSInteger)pageIndexWithTotalIndex:(NSInteger)index
{
    InputEmoticonCatalog *catalog = [self emoticonWithIndex:index];
    NSInteger begin = [self pageIndexWithEmoticon:catalog];//表情开始的地方
    return index - begin;//index 减去begin显示是在pagecontrol的第几个
}

//根据指定位置返回当时emoticon数组
- (InputEmoticonCatalog *)emoticonWithIndex:(NSInteger)index
{
    NSInteger page = 0;
    InputEmoticonCatalog *emoticon;
    for (emoticon in self.tabView.emoticonCatalogs) {
        NSInteger newPage = page + emoticon.pagesCount;
        if (newPage > index) {
            break;
        }
        page = newPage;
    }
    return emoticon;
}

//返回该emotcion所需page页数
- (NSInteger)numberOfPagesWithEmoticon:(InputEmoticonCatalog *)emoticonCatalog
{
    //总个数对每页个数取余
    if (emoticonCatalog.emoticons.count % emoticonCatalog.layout.itemCountInPage == 0) {//为0，能整除，返回pages个数
        return emoticonCatalog.emoticons.count / emoticonCatalog.layout.itemCountInPage;
    }
    else
    {//非0，不能整除，返回pages个数
        return emoticonCatalog.emoticons.count / emoticonCatalog.layout.itemCountInPage + 1;
    }
}

- (void)pageViewScrollEnd:(InputPageView *)pageView currentIndex:(NSInteger)index totolPages:(NSInteger)pages
{
    InputEmoticonCatalog *emoticon = [self emoticonWithIndex:index];
    self.emotPageController.numberOfPages = [emoticon pagesCount];
    self.emotPageController.currentPage = [self pageIndexWithTotalIndex:index];
    NSInteger selectTableIndex = [self.tabView.emoticonCatalogs indexOfObject:emoticon];//根据emoticon从tableview的数组中返回选择的下标
    [self.tabView selectTableIndex:selectTableIndex];//
}
#pragma mark - EmoticonButtonTouchDelegate

- (void)selectedEmoticon:(InputEmoticon *)emoticon catalogID:(NSString *)catalogID//点击表情实现方法
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedEmoticon:catalog:description:)]) {
        [self.delegate selectedEmoticon:emoticon.emoticonID catalog:catalogID description:emoticon.tag];
    }
}
- (void)didPressSend:(id)sender//点击发送
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressSend:)]) {
        [self.delegate didPressSend:sender];
    }
}

#pragma mark - InputEmoticonTableDelegate
- (void)tabView:(InputEmoticonTableView *)tabView didSelectTableIndex:(NSInteger)index
{
    //更新当前显示表情类别
    self.currentCatalogData = tabView.emoticonCatalogs[index];
}

#pragma mark -  Private
- (void)setCurrentCatalogData:(InputEmoticonCatalog *)currentCatalogData
{
    _currentCatalogData = currentCatalogData;
    [self.emoticonPageView scrollToPage:[self pageIndexWithEmoticon:_currentCatalogData]];//滑动到指定位置，里面已有销毁和载入
}

- (InputEmoticonCatalog *)nextCatalogData
{
    if (!self.currentCatalogData) {
        return nil;
    }
    NSInteger index = [self.tabView.emoticonCatalogs indexOfObject:self.currentCatalogData];
    if (index >= self.tabView.emoticonCatalogs.count) {
        return nil;
    }
    else
    {
        return self.tabView.emoticonCatalogs[index + 1];
    }
}

- (NSArray *)allEmoticons
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (InputEmoticonCatalog *catalog in self.tabView.emoticonCatalogs) {
        [array addObjectsFromArray:catalog.emoticons];//添加数组元素
    }
    return array;
}
@end
