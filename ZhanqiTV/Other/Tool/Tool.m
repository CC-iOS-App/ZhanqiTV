//
//  Tool.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/24.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "Tool.h"

@implementation Tool
#pragma mark -- 字符串自适应
+ (CGSize)getStringSize:(NSString *)string withWidth:(CGFloat)width withHeight:(CGFloat)height withFontName:(NSString *)fontName
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:fontName]}  context:nil].size;
    
    return size;
}
@end
