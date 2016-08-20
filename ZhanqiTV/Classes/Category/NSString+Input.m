//
//  NSString+Input.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "NSString+Input.h"

@implementation NSString (Input)

- (NSString *)stringByDeletingPictureResolution//图片分辨率选
{
    NSString *doubleResoulution = @"@2x";
    NSString *tribleResoulution = @"@3x";
    
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResoulution] || [fileName hasSuffix:tribleResoulution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
            res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}
@end
