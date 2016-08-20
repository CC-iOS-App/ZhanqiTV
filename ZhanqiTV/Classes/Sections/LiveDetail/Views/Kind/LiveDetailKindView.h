//
//  LiveDetailKindView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveDetailKindItem.h"
@class LiveDetailKindView;
@protocol LiveDetailKindViewDelegate <NSObject>

- (void)onTouchDetailKind:(LiveDetailKindView *)kindView item:(LiveDetailKindItem *)item;

@end
@interface LiveDetailKindView : UIView
@property (nonatomic, weak) id<LiveDetailKindViewDelegate> delegate;
@end
