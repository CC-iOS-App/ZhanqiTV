//
//  NavigationHandle.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/25.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "NavigationHandle.h"
#import "NavigationAnimator.h"
#import "UIView+YZY.h"
#import "MainTabController.h"
@interface NavigationHandle()<UIGestureRecognizerDelegate,NavigationAnimatorDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interaction;//自定义转场进度

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) NavigationAnimator *animator;

@property (nonatomic, assign) UINavigationControllerOperation currentOperation;

@property (nonatomic,strong) CAGradientLayer *uiPopShadow;

@property (nonatomic,assign) BOOL isAnimating;//是否执行动画
@end
@implementation NavigationHandle


- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        _recognizer.delegate = self;
        _recognizer.delaysTouchesBegan = NO;
        [navigationController.view addGestureRecognizer:_recognizer];
        _animator = [[NavigationAnimator alloc]initWithNavigationController:navigationController];
        _animator.delegate = self;
        _navigationController = navigationController;
    }
    return self;
}
- (void)pan:(UIPanGestureRecognizer *)recognize
{
    UIView *view = recognize.view;
    if (recognize.state == UIGestureRecognizerStateBegan) {
//        返回View的相对于根视图的触摸位置
        CGPoint location = [recognize locationInView:view];
        if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) {
            //手势进度
            self.interaction = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognize.state == UIGestureRecognizerStateChanged)
    {
//      是得到触点在屏幕上与开始触摸点的位移值
        CGPoint translation = [recognize translationInView:view];
        CGFloat d = translation.x / view.width;
        [self.interaction updateInteractiveTransition:d];
    }
    else if (recognize.state == UIGestureRecognizerStateEnded)
    {
        if ([recognize locationInView:view].x > view.width *.5f) {
            [self.interaction finishInteractiveTransition];//完成
        }
        else
        {
            [self.interaction cancelInteractiveTransition];//取消
        }
        self.interaction = nil;//清空
    }
}
#pragma mark -- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{// 交互
    /**
     *  在非交互式动画效果中，该方法返回 nil
     *  交互式转场,自我理解意思是,用户能通过自己的动作来(常见:手势)控制,不同于系统缺省给定的push或者pop(非交互式)
     */
    return self.interaction;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.currentOperation = operation;
    self.animator.currenOperation = operation;
    BOOL cross = [self isUseClearBar:fromVC] || [self isUseClearBar:toVC];
    
    self.animator.animationType = cross ? NavigationAnimationTypeCross : NavigationAnimationTypeNormal;
    
    if (operation == UINavigationControllerOperationPop) {
        [fromVC.view.layer addSublayer:self.uiPopShadow];
    }
    return self.animator;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL forbid = [self isForbidInteractivePop:self.navigationController.topViewController];
    if (forbid || self.isAnimating) {
        return NO;
    }
    UIView *view = gestureRecognizer.view;
    CGPoint location = [gestureRecognizer locationInView:view];
    
    return location.x < 44.f;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [otherGestureRecognizer.view.superview isKindOfClass:[UITableView class]];
}

#pragma mark - Get
- (CAGradientLayer *)uiPopShadow
{
    if (!_uiPopShadow) {
        _uiPopShadow = [CAGradientLayer layer];
        _uiPopShadow.frame = CGRectMake(-6, 0, 6, [MainTabController instance].view.frame.size.height);
        
        _uiPopShadow.startPoint = CGPointMake(1.0, 0.5);
        _uiPopShadow.endPoint = CGPointMake(0, 0.5);
        _uiPopShadow.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.2f] CGColor],(id)[[UIColor clearColor] CGColor], nil];
    }
    return _uiPopShadow;
}
#pragma mark - NavigationAnimatorDelegate

- (void)animationWillStart:(NavigationAnimator *)animator
{
    self.isAnimating = YES;
}
- (void)animationDidEnd:(NavigationAnimator *)animator
{
    self.isAnimating = NO;
}
#pragma mark - Private
- (BOOL)isUseClearBar:(UIViewController *)vc
{
    SEL sel = NSSelectorFromString(@"useClearBar");
    BOOL use = NO;
    if ([vc respondsToSelector:sel]) {//是否实现
        SuppressPerformSelectorLeakWarning(use = (BOOL)[vc performSelector:sel]);//调用为yes
    }
    return use;
}

- (BOOL)isForbidInteractivePop:(UIViewController *)vc
{
    SEL sel = NSSelectorFromString(@"forbidInteractivePop");
    BOOL use = NO;
    if ([vc respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning(use = (BOOL)[vc performSelector:sel]);
    }
    return use;
}
@end
