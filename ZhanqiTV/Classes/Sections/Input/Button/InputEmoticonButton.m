//
//  InputEmoticonButton.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputEmoticonButton.h"
#import "UIImage+YZY.h"
#import "InputEmoticonManager.h"
@implementation InputEmoticonButton

+ (InputEmoticonButton *)iconButtonWithData:(InputEmoticon *)data catalogID:(NSString *)catalogID delegate:(id<EmoticonButtonTouchDelegate>)delegate
{
    InputEmoticonButton *icon = [[InputEmoticonButton alloc]init];
    [icon addTarget:self action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage fetchImage:data.filename];
    icon.emoticonData = data;
    icon.catalogID    = catalogID;
    icon.userInteractionEnabled = YES;
    icon.contentMode  = UIViewContentModeScaleToFill;//铺满
    icon.exclusiveTouch = YES;  //设置了exclusiveTouch的 UIView是事件的第一响应者，那么到你的所有手指离开前，其他的视图UIview是不会响应任何触摸事件的，对于多点触摸事件，这个属性就非常重要，值得注意的是：手势识别（GestureRecognizers）会忽略此属性
    icon.delegate     = delegate;
    [icon setImage:image forState:UIControlStateNormal];
    [icon setImage:image forState:UIControlStateHighlighted];
    
    return icon;
}

- (void)onIconSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedEmoticon:catalogID:)]) {
        [self.delegate selectedEmoticon:self.emoticonData catalogID:self.catalogID];
    }
}
@end
