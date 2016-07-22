//
//  DecodingWayView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupViewController.h"

@protocol DecodingWayDelegate <NSObject>
- (void)hideDecodingWayView;
- (void)didSelectedDecodingWayButton:(NSUInteger)index withString:(NSString *)buttonString;
@end

@interface DecodingWayView : UIView
@property (nonatomic, assign) id<DecodingWayDelegate> delegate;
- (void)appearView;
- (void)hideView;
@end
