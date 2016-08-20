//
//  NavigationHandle.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/25.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationHandle : NSObject<UINavigationControllerDelegate>
@property (nonatomic,strong,readonly) UIPanGestureRecognizer *recognizer;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
