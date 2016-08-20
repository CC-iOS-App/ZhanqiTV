//
//  InputView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputView.h"
#import "SessionCofig.h"
#import "InputEmoticonContainerView.h"
#import "InputMoreContainerView.h"
#import "InputToolBar.h"
#import "UIView+YZY.h"
#import "InputEmoticonDefine.h"
#import "UIConfig.h"
@interface InputView()<UITextFieldDelegate,InputEmoticonProtocol>
{
    UIView *_emoticonView;
    InputType _inputType;//点击类型
    CGFloat _inputTextViewOlderHeight;//记录toolbar以及弹出视图高度
}

@property (nonatomic, weak) id<SessionCofig> inputConfig;
@property (nonatomic, weak) id<InputDelegate> inputDelegate;
@property (nonatomic, weak) id<InputActionDelegate> actionDelegate;
@end
@implementation InputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _recording = NO;
        [self initUIComponents];
    }
    return self;
}

- (void)setInputConfig:(id<SessionCofig>)config
{
    _inputConfig = config;
    //设置最大输入字数
    NSInteger textInputLength = 1000;
    if (_inputConfig && [_inputConfig respondsToSelector:@selector(maxInputLength)]) {
        textInputLength = [_inputConfig maxInputLength];
    }
    self.maxTextLength = textInputLength;
    
    //设置placeholder
    if (_inputConfig && [_inputConfig respondsToSelector:@selector(inputViewPlaceholder)]) {
        NSString *placeholder = [_inputConfig inputViewPlaceholder];
        _toolBar.inputTextFiled.placeHolder = placeholder;
    }
    
    //设置input bar 上的按钮
    if (_inputConfig && [_inputConfig respondsToSelector:@selector(inputBarItemTypes)]) {
        NSArray *types = [_inputConfig inputBarItemTypes];
        [_toolBar setInputBarItemTypes:types];
    }
    //设置表情视图与媒体视图配置
    _moreContainer.config       = config;
    _emoticonContainer.config   = config;
}

- (void)setInputDelegate:(id<InputDelegate>)delegate
{
    _inputDelegate = delegate;
}

- (void)setInputActionDelegate:(id<InputActionDelegate>)actionDelegate
{
    _actionDelegate = actionDelegate;
    _moreContainer.actionDelegate = actionDelegate;
}

//TODO:初始化toolbar
- (void)initUIComponents
{
    self.backgroundColor = [UIColor whiteColor];
    
    _toolBar = [[InputToolBar alloc]initWithFrame:CGRectZero];
    
    [_toolBar.emoticonBtn addTarget:self action:@selector(onTouchEmoticonBtn:) forControlEvents:UIControlEventTouchUpInside];//表情
    
    [_toolBar.moreMediaBtn addTarget:self action:@selector(onTouchMoreBtn:) forControlEvents:UIControlEventTouchUpInside];//更多
    
    [_toolBar.giftBtn addTarget:self action:@selector(onTouchGiftBtn:) forControlEvents:UIControlEventTouchUpInside];//礼物
    
    _toolBar.size = [_toolBar sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];//CGFLOAT_MAX 为float的最大值
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_toolBar];
    
    //设置textFiled配置
    _toolBar.inputTextFiled.delegate = self;
    
    [_toolBar.inputTextFiled setCustomUI];
    [_toolBar.inputTextFiled setPlaceHolder:@"发个弹幕呗"];
    _inputType = InputTypeText;
    
    _inputBottomViewHeight = 0;
    _inputTextViewOlderHeight = [UIConfig topInputViewHeight];//默认高度46
    [self addListenEvents];//添加监听
    
    _moreContainer = [[InputMoreContainerView alloc]initWithFrame:CGRectMake(0, [UIConfig topInputViewHeight], self.width, [UIConfig bottomInputViewHeight])];//更多媒体视图在toolbar下面
    _moreContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _moreContainer.hidden = YES;//默认隐藏
    [self addSubview:_moreContainer];
    
    _emoticonContainer = [[InputEmoticonContainerView alloc]initWithFrame:CGRectMake(0, [UIConfig topInputViewHeight], self.width, [UIConfig bottomInputViewHeight])];//表情视图在toolbar下面
    
    _emoticonContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _emoticonContainer.delegate = self;
    _emoticonContainer.hidden = YES;//默认隐藏
    [self addSubview:_emoticonContainer];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _emoticonContainer.delegate = nil;
    _toolBar.inputTextFiled.delegate = nil;
}

#pragma mark - 外部接口
- (void)setInputTextPlaceHolder:(NSString *)placeHolder
{
    [_toolBar.inputTextFiled setPlaceHolder:placeHolder];
}

#pragma mark - private methods

- (void)addListenEvents{//添加监听
    //显示键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)updateAllButtonImages
{
    if (_inputType == InputTypeText) {//输入框
        [self updateEmotBtnImages:NO];
        [self updateMediaBtnImages:NO];
        [_toolBar.inputTextFiled setHidden:NO];
        [_toolBar.emoticonAndTextBackGroundView setHidden:NO];
    }
    else if (_inputType == InputTypeGift)//礼物
    {
        [self updateEmotBtnImages:NO];
        [self updateMediaBtnImages:NO];
        [_toolBar.inputTextFiled setHidden:NO];
        [_toolBar.emoticonAndTextBackGroundView setHidden:YES];
    }
    else if (_inputType == InputTypeEmot)//表情
    {
        [self updateEmotBtnImages:YES];
        [self updateMediaBtnImages:NO];
        [_toolBar.inputTextFiled setHidden:NO];
        [_toolBar.emoticonAndTextBackGroundView setHidden:NO];
    }
    else//更多媒体
    {
        [self updateEmotBtnImages:NO];
        [self updateMediaBtnImages:YES];
        [_toolBar.inputTextFiled setHidden:NO];
        [_toolBar.emoticonAndTextBackGroundView setHidden:NO];
    }
}

- (CGFloat)getTextViewContentHeight:(UITextView *)textView
{
    return iOS8 ? textView.contentSize.height : ceilf([textView sizeThatFits:textView.frame.size].height);
}
- (void)updateMediaBtnImages:(BOOL)selected//更多媒体图片更新
{
    UIImage *normalImage = [UIImage imageNamed:selected ? @"btn_more_less" : @"btn_more"];
    UIImage *highlightImage = [UIImage imageNamed:selected ? @"btn_more" : @"btn_more_less"];
    [_toolBar.moreMediaBtn setImage:normalImage forState:UIControlStateNormal];
    [_toolBar.moreMediaBtn setImage:highlightImage forState:UIControlStateHighlighted];
}

- (void)updateEmotBtnImages:(BOOL)selected//表情更新
{
    UIImage *normalImage = [UIImage imageNamed:selected ? @"btn_key" : @"btn_face"];
    UIImage *highlightImage = [UIImage imageNamed:selected ? @"btn_face" : @"btn_key"];
    [_toolBar.emoticonBtn setImage:normalImage forState:UIControlStateNormal];
    [_toolBar.emoticonBtn setImage:highlightImage forState:UIControlStateHighlighted];
}
#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.window) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    [UIView animateWithDuration:duration delay:0.f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    BOOL ios7 = ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0);
    //IOS7的横屏UIDevice的宽高不会发生改变，需要手动去调整
    if (ios7 && (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)) {
        //横屏
        toFrame.origin.y -= _inputBottomViewHeight;
        if (toFrame.origin.y == kScreen_width) {
            [self willShowButtomHeight:0];
        }
        else
        {
            [self willShowButtomHeight:toFrame.size.width];
        }
    }
    else
    {
        //竖屏
        toFrame.origin.y = _inputBottomViewHeight;
        if (toFrame.origin.y == kScreen_height) {
            [self willShowButtomHeight:0];
        }
        else
        {
            [self willShowButtomHeight:toFrame.size.height];
        }
    }
}

- (void)willShowButtomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolBar.height + bottomHeight;
    CGRect toFrame =  CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if (bottomHeight == 0 && self.height == self.toolBar.height) {
        return;
    }
    
    self.frame = toFrame;
    
    if (bottomHeight == 0) {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(hideInputView)]) {
            [self.inputDelegate hideInputView];
        }
    }
    else
    {
        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(showInputView)]) {
            [self.inputDelegate showInputView];
        }
    }
    
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
        [self.inputDelegate inputViewSizeToHeight:toHeight showInputView:!(bottomHeight == 0)];
    }
}

- (void)updateInputToViewFrame:(CGRect)rect
{
    self.toolBar.frame          = rect;
    [self.toolBar layoutIfNeeded];
    self.moreContainer.top      = self.toolBar.bottom;
    self.emoticonContainer.top  = self.toolBar.bottom;
}
#pragma mark - button actions
//点击出现表情选择
- (void)onTouchEmoticonBtn:(id)sender
{
    if (_inputType != InputTypeEmot) {
        _inputType = InputTypeEmot;
        _inputBottomViewHeight = [UIConfig bottomInputViewHeight];
        [self bringSubviewToFront:_emoticonContainer];//将表情子视图放在最上方
        [_moreContainer setHidden:YES];
        [_emoticonContainer setHidden:NO];
        if ([self.toolBar.inputTextFiled isFirstResponder]) {//如果输入框为第一响应
            [self.toolBar.inputTextFiled resignFirstResponder];//键盘消失
        }
        void (^animations)() = ^{
            [self willShowButtomHeight:_inputBottomViewHeight];
        };
        [UIView animateWithDuration:0.25 animations:animations];
    }
    else
    {
        _inputBottomViewHeight = 0;
        _inputType = InputTypeText;
        [self.toolBar.inputTextFiled becomeFirstResponder];//弹出键盘
    }
    [self updateAllButtonImages];//更新点击后状态
}

//点击出现礼物选择
- (void)onTouchGiftBtn:(id)sender
{
    if (_inputType != InputTypeGift) {
        _inputType = InputTypeGift;
        
        [_moreContainer setHidden:YES];
        [_emoticonContainer setHidden:YES];
        if ([self.toolBar.inputTextFiled isFirstResponder]) {
            [self.toolBar.inputTextFiled resignFirstResponder];
        }
        void(^animations)() = ^{
            
        };
        [UIView animateWithDuration:.25f animations:animations];
    }
    [self updateAllButtonImages];
    //在弹出礼物界面更新完之后 把inputtype再转化为text
    _inputType = InputTypeText;
}
//点击出现更多媒体
- (void)onTouchMoreBtn:(id)sender
{
    if (_inputType != InputTypeMeidia) {
        _inputType = InputTypeMeidia;
        [self bringSubviewToFront:_moreContainer];
        [_moreContainer setHidden:NO];
        [_emoticonContainer setHidden:YES];
        _inputBottomViewHeight = [UIConfig bottomInputViewHeight];
        if ([self.toolBar.inputTextFiled isFirstResponder]) {
            [self.toolBar.inputTextFiled resignFirstResponder];
        }
        void(^animaitons)() = ^{
            [self willShowButtomHeight:_inputBottomViewHeight];
        };
        [UIView animateWithDuration:0.25 animations:animaitons];
    }
    else
    {
        _inputBottomViewHeight = 0;
        _inputType = InputTypeText;
        [self.toolBar.inputTextFiled becomeFirstResponder];
    }
    [self updateAllButtonImages];
}

//TODO:UIView EndEditing
- (BOOL)endEditing:(BOOL)force
{
    BOOL endEditing = [super endEditing:force];
    
    if (![self.toolBar.inputTextFiled isFirstResponder]) {//如果文本框不为第一响应
        _inputBottomViewHeight = 0.0;
        _inputType = InputTypeText;
        UIViewAnimationCurve curve = UIViewAnimationCurveEaseInOut;
        void(^animations)() = ^{
            
        };
        NSTimeInterval duration = 0.25;
        [UIView animateWithDuration:duration delay:0.f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
        
    }
    return endEditing;
}

#pragma mark - TextFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _inputType = InputTypeText;//将输出类型改为text
    [textField becomeFirstResponder];//弹出键盘
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];//关闭键盘
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if ([self.actionDelegate respondsToSelector:@selector(onSendText:)] && textField.text.length > 0) {
            [self.actionDelegate onSendText:textField.text];
            textField.text = @"";//消息发送后清空输入框
            [textField layoutIfNeeded];//调用layoutSubviews进行布局
        }
        return NO;
    }
    
    NSString *str = [textField.text stringByAppendingString:string];//在输入框中添加新输入文字
    if (str.length > self.maxTextLength) {//如果原来的文本添加了输入的text以后大于限制的最大长度，则返回no
        return NO;
    }
    return YES;
}

#pragma mark - InputEmoticonProtocol

//选择表情
- (void)selectedEmoticon:(NSString *)emoticonID catalog:(NSString *)emotCatalogID description:(NSString *)description
{
    if (!emotCatalogID) {//删除键
//        NSRange range = [self rangeForEmoticon];
//        [self deleteTextRange:range];
    }
    else
    {
        if ([emotCatalogID isEqualToString:EmojiCatalog]) {
            [self.toolBar.inputTextFiled insertText:description];//插入emoji表情的tag
        }
        else//暂时没有任何贴图
        {
            //发送贴图消息
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onSelectChartlet:catalog:)]) {
                [self.actionDelegate onSelectChartlet:emoticonID catalog:emotCatalogID];
            }
        }
    }
}

//发送表情
- (void)didPressSend:(id)sender
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(onSendText:)] && [self.toolBar.inputTextFiled.text length] > 0) {
        [self.actionDelegate onSendText:self.toolBar.inputTextFiled.text];
        self.toolBar.inputTextFiled.text = @"";
        
    }
}

//- (void)deleteTextRange:(NSRange)range
//{
//    NSString *text = [self.toolBar.inputTextFiled text];
//    if (range.location + range.length <= [text length] && range.location != NSNotFound && range.length != 0) {//所选择位置小于等于文字总长度和有空格并且长度不为0
//        NSString *newText = [text stringByReplacingCharactersInRange:range withString:@""];//将指定range当中的文字替换
//        NSRange newSelectRange = NSMakeRange(range.location, 0);
//        [self.toolBar.inputTextFiled setText:newText];//设置光标位置
//    }
//}
//
//- (NSRange)rangeForEmoticon//这个方法没懂
//{
//    NSString *text = [self.toolBar.inputTextFiled text];
//    NSRange range = [self.toolBar.inputTextFiled selectedRange];//光标所在位置
//    NSString *selectedText = range.length ? [text substringWithRange:range] : text;
//    NSInteger endLocation = range.location;
//    if (endLocation <= 0) {
//        return NSMakeRange(NSNotFound, 0);
//    }
//    NSInteger index = -1;
//    
//    if ([selectedText hasSuffix:@"]"]) {//文字信息以]为结尾
//        for (NSInteger i = endLocation; i >= endLocation - 4 && i - 1 >=0; i--) {
//            NSRange subRange = NSMakeRange(i - 1, 1);
//            NSString *subString = [text substringWithRange:subRange];
//            if ([subString compare:@"["] == NSOrderedSame) {//如果subString 等于右边
//                index = i - 1;
//                break;
//            }
//        }
//        
//    }
//    if (index == -1) {
//        return NSMakeRange(endLocation - 1, 1);
//    }
//    else
//    {
//        NSRange emoticonRange = NSMakeRange(index, endLocation - index);
//        NSString *name = [text substringWithRange:emoticonRange];
//        
//        InputEmoticon *icon = [[InputEmoticonManager sharedManager] emoticonByTag:name];
//        
//        return icon ? emoticonRange : NSMakeRange(endLocation - 1, 1);
//    }
//    return range;
//}
@end
