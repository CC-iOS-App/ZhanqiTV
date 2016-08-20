//
//  MediaItem.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MediaItem.h"

@implementation MediaItem

+ (MediaItem *)item:(NSInteger)tag normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    MediaItem *item = [[MediaItem alloc]init];
    
    item.tag                = tag;
    item.normalImage        = normalImage;
    item.highlightedImage   = highlightedImage;
    item.selectedImage      = selectedImage;
    item.title              = title;
    return item;
}
@end
