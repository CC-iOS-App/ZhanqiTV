//
//  CommonTableDelegate.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/29.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTableDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) CGFloat defaultSeparatorLeftEdge;//默认左边距
- (instancetype)initWithTableData:(NSArray *(^)(void))data;
@end
