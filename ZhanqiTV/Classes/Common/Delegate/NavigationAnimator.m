//
//  NavigationAnimatorDelegate.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/25.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "NavigationAnimator.h"
#import "UIView+YZY.h"
#import "MainTabController.h"
@implementation NavigationAnimator
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;//动画执行时间
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.currenOperation) {
        case UINavigationControllerOperationPop:
            [self popAnimation:transitionContext];
            break;
        case UINavigationControllerOperationPush:
            [self pushAnimation:transitionContext];
            break;
        default:
            break;
    }
}
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];//到达控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];//出发控制器
    
    UIView *containerView = [transitionContext containerView];
    
    UINavigationController *navigationController = fromViewController.navigationController;//出发控制器的导航控制器
    UITabBarController *tabbarController = fromViewController.tabBarController;//出发控制器的标签控制器
    
    //使用xib可能会出现view的size不对的情况
    CGRect frame = fromViewController.view.frame;
    if ((toViewController.edgesForExtendedLayout & UIRectEdgeTop) == 0) {
//        相对于源矩形原点rect（左上角的点）沿x轴和y轴偏移, 再rect基础上沿x轴和y轴偏移
        frame = CGRectOffset(navigationController.view.frame, 0, navigationController.navigationBar.bottom);
    }
    if ((toViewController.edgesForExtendedLayout & UIRectEdgeBottom ) == 0) {
//        这个函数的功能很简单，就是将一个 CGRect 切割成两个 CGRect ；其中， rect 参数是你要切分的对象； slice 是一个指向切出的 CGRect 的指针； remainder 是指向切割后剩下的 CGRect 的指针； amount 是你要切割的大小；最后一个参数 edge 是一个枚举值，代表 amount 开始计算的方向，假设 amount 为 10.0 那么：
//        
//        CGRectMinXEdge 代表在 rect 从左往右数 10 个单位开始切割
//        CGRectMaxXEdge 代表在 rect 从右往左数 10 个单位开始切割
//        CGRectMinYEdge 代表在 rect 从上往下数 10 个单位开始切割
//        CGRectMaxYEdge 代表在 rect 从下往上数 10 个单位开始切割
        CGRect slice = CGRectZero;
        CGRect remainder = CGRectZero;
        CGRectDivide(frame, &slice, &remainder, tabbarController.tabBar.height, CGRectMaxYEdge);
        frame = remainder;
    }
    toViewController.view.frame = frame;
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    CGFloat width = containerView.width;
    toViewController.view.left = width;
    
    [self callAnimationWillStart];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.right = width * 0.5;
        toViewController.view.right = width;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [self callAnimationDidEnd];
    }];
}
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat snapshootHeight = [UIApplication sharedApplication].statusBarFrame.size.height + fromViewController.navigationController.navigationBar.height;
    
    UIView *fakeBar = [fromViewController.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 0, fromViewController.view.width, snapshootHeight) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
    UINavigationBar *tureBar = toViewController.navigationController.navigationBar;
    
    BOOL hidesBottomBar = toViewController.hidesBottomBarWhenPushed && self.navigationController.viewControllers.firstObject != toViewController;
    
    UITabBar *tabbar = [MainTabController instance].tabBar;
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    if (!hidesBottomBar) {
        [containerView addSubview:tabbar];
    }
    if (self.animationType == NavigationAnimationTypeCross) {
        [containerView addSubview:tureBar];
        [fromViewController.view addSubview:fakeBar];
    }
    [containerView addSubview:fromViewController.view];
    
    CGFloat width = containerView.width;
    
    toViewController.view.right = width * 0.5;
    tabbar.right = width * 0.5;
    
    [self callAnimationWillStart];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.left = width;
        toViewController.view.right = width;
        tabbar.right = width;
        fakeBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[MainTabController instance].view addSubview:tabbar];
        [toViewController.navigationController.view addSubview:tureBar];
        [fakeBar removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [self callAnimationDidEnd];
    }];
}
- (void)callAnimationWillStart
{
    if ([self.delegate respondsToSelector:@selector(animationWillStart:)]) {
        [self.delegate animationWillStart:self];
    }
}
- (void)callAnimationDidEnd
{
    if ([self.delegate respondsToSelector:@selector(animationDidEnd:)]) {
        [self.delegate animationDidEnd:self];
    }
}
@end
