//
//  LiveDetailKindItem.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/20.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "LiveDetailKindItem.h"

@implementation LiveDetailKindItem
+ (LiveDetailKindItem *)item:(NSInteger)tag normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    LiveDetailKindItem *item = [[LiveDetailKindItem alloc]init];
    
    item.tag                = tag;
    item.normalImage        = normalImage;
    item.highlightedImage   = highlightedImage;
    item.selectedImage      = selectedImage;
    item.title              = title;
    return item;
}
@end
