//
//  Tool.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/24.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tool : NSObject
#pragma mark -- 字符串自适应
+ (CGSize)getStringSize:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFontName:(NSString *)fontName;
@end
