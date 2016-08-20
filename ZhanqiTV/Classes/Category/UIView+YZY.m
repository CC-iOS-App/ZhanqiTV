//
//  UIView+YZY.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/25.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "UIView+YZY.h"
#import <objc/runtime.h>
@implementation UIView (YZY)



/*********/
 /*******/
/*********/

- (CGFloat)left
{
    return self.frame.origin.x;
}

/*********/
/*******/
/*********/

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)top
{
    return self.frame.origin.y;
}

/*********/
/*******/
/*********/

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

/*********/
/*******/
/*********/

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

/*********/
/*******/
/*********/

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)centerX
{
    return self.center.x;
}

/*********/
/*******/
/*********/

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

/*********/
/*******/
/*********/

- (CGFloat)centerY
{
    return self.center.y;
}

/*********/
/*******/
/*********/

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

/*********/
/*******/
/*********/

- (CGFloat)width
{
    return self.frame.size.width;
}

/*********/
/*******/
/*********/

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)height
{
    return self.frame.size.height;
}

/*********/
/*******/
/*********/

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGPoint)origin
{
    return self.frame.origin;
}

/*********/
/*******/
/*********/

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGSize)size
{
    return self.frame.size;
}

/*********/
/*******/
/*********/

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (UIViewController *)viewController
{
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end

@implementation UIView (YZYPresent)

static char PresentedViewAddress;  //被Present的view
static char PresentingViewAddress; //正在被Present其它视图的view

#define AnimateDuartion .25f

- (void)presentView:(UIView *)view animated:(BOOL)animated complete:(void (^)())complete
{
    if (!self.window) {//如果不是当前窗口
        return;
    }
    [self.window addSubview:view];
    
    //objc_setAssociatedObject需要四个参数：源对象，关键字，关联的对象和一个关联策略。
    objc_setAssociatedObject(self, &PresentedViewAddress, view, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &PresentingViewAddress, self, OBJC_ASSOCIATION_RETAIN);
    if (animated) {
        [self doAlertAnimate:view complete:complete];
    }
    else
    {
        view.center = self.window.center;
    }
}

- (UIView *)presentView
{
//    使用objc_getAssociatedObject从self中获取到所关联的对象
    UIView *view = objc_getAssociatedObject(self, &PresentedViewAddress);
    return view;
}

- (void)dismissPresentView:(BOOL)animated complete:(void (^)())complete
{
    UIView *view = objc_getAssociatedObject(self, &PresentedViewAddress);
    if (animated) {
        [self doHideAnimate:view complete:complete];//执行消失动画
    }
    else
    {
        [view removeFromSuperview];
        [self cleanAssocaiteObject];
    }
    
}

- (void)hideSelf:(BOOL)animated complete:(void (^)())complete
{
    UIView *baseView = objc_getAssociatedObject(self, &PresentingViewAddress);
    if (!baseView) {
        return;
    }
    [baseView dismissPresentView:YES complete:complete];
    [self cleanAssocaiteObject];
}

- (void)onPressBkg:(id)sender
{
    [self dismissPresentView:YES complete:nil];
}

#pragma mark - Animation
- (void)doAlertAnimate:(UIView *)view complete:(void(^)())complete
{
    CGRect bounds = view.bounds;
    
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.duration = AnimateDuartion;//时间
    scaleAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    scaleAnimation.toValue = [NSValue valueWithCGRect:bounds];
    
    //移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration = AnimateDuartion;//时间
    moveAnimation.fromValue = [NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil]];
    moveAnimation.toValue = [NSValue valueWithCGPoint:self.window.center];
    
    //组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
//    设置动画的“时机”效果。就是动画自身的“节奏”：比如：开始快，结束时变慢；开始慢，结束时变快；匀速；等，在动画过程中的“时机”效果。
    group.beginTime = CACurrentMediaTime();
    group.duration = AnimateDuartion;
    group.animations = [NSArray arrayWithObjects:scaleAnimation,moveAnimation, nil];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;//是否动画完成后，动画效果从设置的layer上移除
    group.autoreverses = NO;
    
    [self hideAllSubView:view];//先隐藏所有subview
    [view.layer addAnimation:group forKey:@"groupAnimationAlert"];
    //在指定时间后执行
    __weak UIView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimateDuartion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.layer.bounds = bounds;
        view.layer.position = weakSelf.superview.center;
        [weakSelf showAllSubView:view];
        if (complete) {
            complete();
        }
    });
}

- (void)doHideAnimate:(UIView *)alertView complete:(void(^)())complete
{
    if (!alertView) {
        return;
    }
    //缩小
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.duration = AnimateDuartion;
    scaleAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    
    CGPoint position = self.center;
    //移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration = AnimateDuartion;//时间
    moveAnimation.toValue = [NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil]];//
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = AnimateDuartion;
    group.animations = [NSArray arrayWithObjects:scaleAnimation,moveAnimation, nil];//动画组
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;//填充模式
    group.delegate = self;
    group.removedOnCompletion = NO;
    group.autoreverses = NO;
    
    alertView.layer.bounds = self.bounds;
    alertView.layer.position = position;
    alertView.layer.needsDisplayOnBoundsChange = YES;
    [self hideAllSubView:alertView];
    
    alertView.backgroundColor = [UIColor clearColor];
    
    [alertView.layer addAnimation:group forKey:@"groupAnimationHide"];
    
    //在指定时间后执行
    __weak UIView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimateDuartion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView removeFromSuperview];
        [weakSelf cleanAssocaiteObject];
        [weakSelf showAllSubView:alertView];
        if (complete) {
            complete();
        }
    });
}

static char *HideViewsAddress = "hideViewsAddress";
- (void)hideAllSubView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if (subView.hidden) {//如果该subView的hidden 为yes 加入数组
            [array addObject:subView];
        }
        objc_setAssociatedObject(self, &HideViewsAddress, array, OBJC_ASSOCIATION_RETAIN);
        subView.hidden = YES;
    }
}

- (void)showAllSubView:(UIView *)view
{
    //不明白
    NSMutableArray *array = objc_getAssociatedObject(self, &HideViewsAddress);
    for (UIView *subView in view.subviews) {
        subView.hidden = [array containsObject:subView];
    }
}

- (void)cleanAssocaiteObject
{
    objc_setAssociatedObject(self, &PresentedViewAddress, nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &PresentingViewAddress, nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &HideViewsAddress, nil, OBJC_ASSOCIATION_RETAIN);
}
@end