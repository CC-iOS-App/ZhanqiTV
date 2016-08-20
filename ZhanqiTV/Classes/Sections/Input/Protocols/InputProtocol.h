//
//  InputProtocol.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MediaItem;
@protocol InputActionDelegate <NSObject>

@optional

- (void)onTapMediaItem:(MediaItem *)item;

- (void)onTextChanged:(id)sender;

- (void)onSendText:(NSString *)text;//发送文本信息

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId;

- (void)onCancelRecording;

- (void)onStopRecording;

- (void)onStartRecording;
@end
