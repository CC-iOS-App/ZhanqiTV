//
//  UIView+ZhanqiTVKit.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/30.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "UIView+ZhanqiTVKit.h"

@implementation UIView (ZhanqiTVKit)

- (CGFloat)nim_left {
    return self.frame.origin.x;
}

/*********/
/*******/
/*********/

- (void)setNim_left:(CGFloat)nim_left{
    CGRect frame = self.frame;
    frame.origin.x = nim_left;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)nim_top {
    return self.frame.origin.y;
}

/*********/
/*******/
/*********/

- (void)setNim_top:(CGFloat)nim_top{
    CGRect frame = self.frame;
    frame.origin.y = nim_top;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)nim_right {
    return self.frame.origin.x + self.frame.size.width;
}

/*********/
/*******/
/*********/

- (void)setNim_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)nim_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

/*********/
/*******/
/*********/

- (void)setNim_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)nim_centerX {
    return self.center.x;
}

/*********/
/*******/
/*********/

- (void)setNim_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

/*********/
/*******/
/*********/

- (CGFloat)nim_centerY {
    return self.center.y;
}

/*********/
/*******/
/*********/

- (void)setNim_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

/*********/
/*******/
/*********/

- (CGFloat)nim_width {
    return self.frame.size.width;
}

/*********/
/*******/
/*********/

- (void)setNim_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGFloat)nim_height {
    return self.frame.size.height;
}

/*********/
/*******/
/*********/

- (void)setNim_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGPoint)nim_origin {
    return self.frame.origin;
}

/*********/
/*******/
/*********/

- (void)setNim_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (CGSize)nim_size {
    return self.frame.size;
}

/*********/
/*******/
/*********/

- (void)setNim_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/*********/
/*******/
/*********/

- (UIViewController *)nim_viewController
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
