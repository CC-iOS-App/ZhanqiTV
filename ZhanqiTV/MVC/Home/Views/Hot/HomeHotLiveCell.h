//
//  HotLiveCell.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHotLiveCell : UICollectionViewCell
@property (nonatomic, strong) UIViewController *viewController;//

- (void)resetModel:(HomeListModel *)model;
- (void)resetArray:(NSMutableArray *)array;
@end
