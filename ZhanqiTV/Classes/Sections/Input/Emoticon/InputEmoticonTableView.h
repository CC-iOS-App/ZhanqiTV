//
//  InputEmoticonTableView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputEmoticonTableView;

@protocol InputEmoticonTableDelegate <NSObject>

- (void)tabView:(InputEmoticonTableView *)tabView didSelectTableIndex:(NSInteger) index;

@end

@interface InputEmoticonTableView : UIControl
@property (nonatomic,strong) NSArray *emoticonCatalogs;//表情类型数组

@property (nonatomic,strong) UIButton * sendButton;//发送按钮

@property (nonatomic,weak)   id<InputEmoticonTableDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame catalogs:(NSArray*)emoticonCatalogs;

//选择表情类型
- (void)selectTableIndex:(NSInteger)index;
@end
