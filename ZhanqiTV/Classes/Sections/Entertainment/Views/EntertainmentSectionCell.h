//
//  EntertainmentSectionCell.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntertainmentSectionCell : UICollectionReusableView
@property (nonatomic, strong) UIView *headerView;//存放右边的图片以及文字
- (void)resetHotTitle:(NSString *)title;
- (void)resetOtherTitle:(EntertainmentOtherModel *)model;
- (void)resetChangeHostTitle:(NSString *)title;
@end
