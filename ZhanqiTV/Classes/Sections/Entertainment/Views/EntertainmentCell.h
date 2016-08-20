//
//  EntertainmentCell.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntertainmentCell : UICollectionViewCell

//热门直播
- (void)resetHotModel:(EntertainmentHotRoomRooms *)model;
//其它直播
- (void)resetOtherModel:(EntertainmentOtherList *)model;
//百变主播
- (void)resetChangeModel:(EntertainmentChangedRooms *)model;
@end
