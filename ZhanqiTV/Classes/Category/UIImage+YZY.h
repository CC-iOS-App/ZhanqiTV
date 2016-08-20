//
//  UIImage+YZY.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (YZY)

/**
 *  根据图片名或者图片地址获取图片
 *
 *  @param  imageNameOrPath         图片名字或者地址
 */
+ (UIImage *)fetchImage:(NSString *)imageNameOrPath;

+ (UIImage *)fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId;

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSize;

+ (UIImage *)imageInKit:(NSString *)imageName;

- (UIImage *)imageForAvatarUpload;

@end
