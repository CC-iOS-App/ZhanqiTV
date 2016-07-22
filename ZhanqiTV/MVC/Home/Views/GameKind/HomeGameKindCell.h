//
//  HomeGameKindView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendGameModel.h"
@interface HomeGameKindCell : UICollectionViewCell
@property (nonatomic, strong) UIViewController *viewController;
- (void)resetArray:(RecommendSuperGameModel *)model;
@end
