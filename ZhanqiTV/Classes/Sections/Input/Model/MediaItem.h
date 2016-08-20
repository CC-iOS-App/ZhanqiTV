//
//  MediaItem.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaItem : NSObject
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSString *title;

+ (MediaItem *)item:(NSInteger)tag
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
      selectedImage:(UIImage *)selectedImage
              title:(NSString *)title;
@end
