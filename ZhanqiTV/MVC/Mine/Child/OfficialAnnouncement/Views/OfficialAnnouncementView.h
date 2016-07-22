//
//  OfficialAnnouncementView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/1.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

@protocol OfficialAnnouncementViewDelegate <NSObject>

- (void)didSelectAnnouncementButton:(NSUInteger)index;

@end
#import <UIKit/UIKit.h>

@interface OfficialAnnouncementView : UIView
@property (nonatomic, assign) id<OfficialAnnouncementViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)array;
- (void)didSelectedButton:(NSInteger)index;
@end
