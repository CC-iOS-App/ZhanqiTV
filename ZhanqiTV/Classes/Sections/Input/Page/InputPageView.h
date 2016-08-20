//
//  InputPageView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputPageView;

@protocol InputPageViewDataSource <NSObject>

/**
 *  总页数
 *  @param  pageView
 */
- (NSInteger)numberOfPages:(InputPageView *)pageView;

/**
 *  返回指定位置view
 *  @param  pageView
 *  @param  index       指定位置
 */
- (UIView *)pageView:(InputPageView *)pageView viewInPage:(NSInteger)index;

@end

@protocol InputPageViewDelegate <NSObject>

@optional
/**
 *  滑动结束后调用
 *  @param  pageView
 *  @param  index       当前页
 *  @param  pages       总页数
 */
- (void)pageViewScrollEnd:(InputPageView *)pageView
             currentIndex:(NSInteger)index
               totolPages:(NSInteger)pages;

/**
 *  滑动结束后调用
 *  @param  pageView
 */
- (void)pageViewDidScroll:(InputPageView *)pageView;
/**
 *  是否动画滑动
 */
- (BOOL)needScrollAnimation;

@end
@interface InputPageView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak)   id<InputPageViewDataSource> dataSource;
@property (nonatomic, weak)   id<InputPageViewDelegate>   pageViewDelegate;
/**
 *  滑动到指定视图
 *  @param page     你所选择的指定位置
 */
- (void)scrollToPage:(NSInteger)page;
/**
 *  返回指定的view
 *  @param index    在所有表情位置中选择指定下标
 */
- (UIView *)viewAtIndex:(NSInteger)index;
/**
 *  在每次载入新的view时刷新数据
 */
- (void)reloadData;
/**
 *  返回当前选中page所在index
 */
- (NSInteger)currentPage;

//TODO:暂时没用到，但是写了
//旋转相关方法，这两个方法必须配对调用，否则会有问题
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;
@end
