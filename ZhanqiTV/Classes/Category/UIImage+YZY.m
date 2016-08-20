//
//  UIImage+YZY.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "UIImage+YZY.h"
#import "InputEmoticonDefine.h"
@implementation UIImage (YZY)

+ (UIImage *)fetchImage:(NSString *)imageNameOrPath
{
    UIImage *image = [UIImage imageNamed:imageNameOrPath];
    if (!image) {
        image = [UIImage imageWithContentsOfFile:imageNameOrPath];
    }
    return image;
}

+ (UIImage *)fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId
{
    if ([chartletId isEqualToString:EmojiCatalog]) {
        return [UIImage imageNamed:imageName];
    }
    NSString *subDirectory = [NSString stringWithFormat:@"%@/%@/%@",ChartletChartletCatalogPath,chartletId,ChartletChartletCatalogContentPath];
    //先拿2倍图
    NSString *doubleImage = [imageName stringByAppendingString:@"@2x"];
    NSString *tribleImage = [imageName stringByAppendingString:@"@3x"];
    NSString *bundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:subDirectory];
    NSString *path = nil;
    
    NSArray *array = [NSBundle pathsForResourcesOfType:nil inDirectory:bundlePath];
    NSString *fileExt = [[array.firstObject lastPathComponent] pathExtension];
    if ([UIScreen mainScreen].scale == 3.0) {
        path = [NSBundle pathForResource:tribleImage ofType:fileExt inDirectory:bundlePath];
    }
    path = path ? path : [NSBundle pathForResource:doubleImage ofType:fileExt inDirectory:bundlePath];//没有3倍图取2倍图
    path = path ? path : [NSBundle pathForResource:imageName ofType:fileExt inDirectory:bundlePath];//没有2倍图取1倍图
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize minSize:(CGSize)imageMinSize maxSize:(CGSize)imageMaxSize
{
    CGSize size;
    
    return size;
}

+ (UIImage *)imageInKit:(NSString *)imageName
{
    NSString *name = [InputBundleName stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:name];
}

- (UIImage *)imageForAvatarUpload
{
    return nil;
}
@end
