//
//  InputEmoticonContainerView.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/5.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputPageView.h"
#import "InputEmoticonManager.h"
#import "InputEmoticonTableView.h"
#import "SessionCofig.h"

@class InputEmoticonCatalog;
@class InputEmoticonTableView;

@protocol InputEmoticonProtocol <NSObject>

- (void)didPressSend:(id)sender;//发送表情

- (void)selectedEmoticon:(NSString *)emoticonID catalog:(NSString *)emotCatalogID description:(NSString *)description;//选择表情

@end
@interface InputEmoticonContainerView : UIView<InputPageViewDataSource,InputPageViewDelegate>

@property (nonatomic, strong) InputPageView *emoticonPageView;//承载表情的view
@property (nonatomic, strong) UIPageControl *emotPageController;//
@property (nonatomic, strong) InputEmoticonCatalog    *currentCatalogData;//当前加载的表情类型
@property (nonatomic, readonly) InputEmoticonCatalog    *nextCatalogData;//下一个表情类型
@property (nonatomic, readonly) NSArray *allEmoticons;//所有表情类型数组
@property (nonatomic, strong) InputEmoticonTableView   *tabView;//底部选择表情类型控件
@property (nonatomic, weak) id<InputEmoticonProtocol> delegate;
@property (nonatomic, weak) id<SessionCofig> config;
@end
