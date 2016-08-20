//
//  NavigationAnimatorDelegate.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/25.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NavigationAnimationType){
    NavigationAnimationTypeNormal,
    NavigationAnimationTypeCross,
};

@class NavigationAnimator;
@protocol NavigationAnimatorDelegate <NSObject>
- (void)animationWillStart:(NavigationAnimator *)animator;
- (void)animationDidEnd:(NavigationAnimator *)animator;
@end
@interface NavigationAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, assign) UINavigationControllerOperation currenOperation;

@property (nonatomic, assign) NavigationAnimationType animationType;

@property (nonatomic, weak) id<NavigationAnimatorDelegate> delegate;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
