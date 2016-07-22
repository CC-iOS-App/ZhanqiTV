//
//  SetupViewController.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecodingWayView.h"
@interface SetupViewController : UIViewController
@property (nonatomic, assign) BOOL switchIsOn;//YES or No
@property (nonatomic, strong) NSString *decodingWayString;//解码方式
@end
