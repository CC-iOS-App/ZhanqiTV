//
//  InputMoreContainerView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputProtocol.h"
#import "SessionCofig.h"
@interface InputMoreContainerView : UIView
@property (nonatomic, weak) id<SessionCofig> config;
@property (nonatomic, weak) id<InputActionDelegate> actionDelegate;
@end
