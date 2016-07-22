//
//  MineHeaderTableCell.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/24.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//
@protocol MineHeaderViewCellDelegate <NSObject>

- (void)didSelectInfoButton:(NSUInteger)index;

@end
#import <UIKit/UIKit.h>

@interface MineHeaderTableCell : UITableViewCell
@property (nonatomic, assign)id<MineHeaderViewCellDelegate> delegate;
@property (nonatomic, strong)NSString *gold;//金币
@property (nonatomic, strong)NSString *coin;//战旗币
@property (nonatomic, strong)NSString *name;//昵称

- (void)addLoginedView;
- (void)loginOutRemoveView;
@end
