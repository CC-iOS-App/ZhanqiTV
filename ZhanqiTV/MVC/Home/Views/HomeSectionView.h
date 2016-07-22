//
//  HomeSectionView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/12.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSectionView : UICollectionReusableView
@property (nonatomic, strong) UIView *headerView;//存放右边的图片以及文字
- (void)resetTitle:(HomeListModel *)model;
@end
