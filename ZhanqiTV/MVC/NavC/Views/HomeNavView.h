//
//  HomeNavView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNavDelegate <NSObject>

- (void)didSelectButton:(NSInteger)index;

@end
@interface HomeNavView : UIView
@property (nonatomic, assign) id <HomeNavDelegate> delegate;
@end
