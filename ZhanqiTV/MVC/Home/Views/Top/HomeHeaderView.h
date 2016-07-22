//
//  HomeHeaderView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/12.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShufflingRoomModel.h"
@interface HomeHeaderView : UICollectionReusableView
@property (nonatomic, strong) UIViewController *viewController;//
- (void)resetModel:(ShufflingSuperRoomModel *)model;
@end
