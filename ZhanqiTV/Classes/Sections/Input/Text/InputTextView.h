//
//  InputTextView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextView : UITextView

@property (nonatomic, strong) NSString *placeHolder;

- (void)setCustomUI;
@end
