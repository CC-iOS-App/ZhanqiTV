//
//  InputEmoticonTableView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputEmoticonTableView.h"
#import "UIView+YZY.h"
#import "InputEmoticonManager.h"
#import "InputEmoticonDefine.h"
#import "UIImage+YZY.h"
const NSInteger InputEmoticonTabViewHeight = 35;//选择表情类型控件高度
const NSInteger InputEmoticonSendButtonWidth = 50;//发送按钮宽度

const CGFloat InputLineBoarder = .5f;//表情类型选择与表情详情之间间隔线高度

@interface InputEmoticonTableView()

@property (nonatomic,strong) NSMutableArray * tabs;//存放按钮数组

@property (nonatomic,strong) NSMutableArray * seps;//存放表情类型之间间隔线数组

@end


@implementation InputEmoticonTableView
//初始化各类数据
- (instancetype)initWithFrame:(CGRect)frame catalogs:(NSArray*)emoticonCatalogs{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, InputEmoticonTabViewHeight)];
    if (self) {
        _emoticonCatalogs = emoticonCatalogs;
        _tabs = [[NSMutableArray alloc] init];
        _seps = [[NSMutableArray alloc] init];
        UIColor *sepColor = UIColorFromRGB(0x8A8E93);
        for (InputEmoticonCatalog * catelog in emoticonCatalogs) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage fetchImage:catelog.icon] forState:UIControlStateNormal];
            [button setImage:[UIImage fetchImage:catelog.iconPressed] forState:UIControlStateHighlighted];
            [button setImage:[UIImage fetchImage:catelog.iconPressed] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onTouchTab:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            [self addSubview:button];
            [_tabs addObject:button];
            
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, InputLineBoarder,InputEmoticonTabViewHeight)];
            sep.backgroundColor = sepColor;
            [_seps addObject:sep];
            [self addSubview:sep];
        }
        //初始化发送按钮
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_sendButton setBackgroundColor:UIColorFromRGB(0x0079FF)];
        
        _sendButton.height = InputEmoticonTabViewHeight;
        _sendButton.width = InputEmoticonSendButtonWidth;
        [self addSubview:_sendButton];
        
        //表情类型选择与表情详情间隔线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.width,InputLineBoarder)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view.backgroundColor = sepColor;
        [self addSubview:view];
    }
    return self;
}

- (void)onTouchTab:(id)sender{
    NSInteger index = [self.tabs indexOfObject:sender];
    [self selectTableIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectTableIndex:)]) {
        [self.delegate tabView:self didSelectTableIndex:index];
    }
}


- (void)selectTableIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.tabs.count ; i++) {
        UIButton *btn = self.tabs[i];
        btn.selected = i == index;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //设置各个按钮位置，此处我认为为不安全创建
    CGFloat spacing = 10;
    CGFloat left    = spacing;
    for (NSInteger index = 0; index < self.tabs.count ; index++) {
        UIButton *button = self.tabs[index];
        button.left = left;
        button.centerY = self.height * .5f;
        
        UIView *sep = self.seps[index];
        sep.left = button.right + spacing;
        left = sep.right + spacing;
    }
    _sendButton.right = self.width;
}

@end
