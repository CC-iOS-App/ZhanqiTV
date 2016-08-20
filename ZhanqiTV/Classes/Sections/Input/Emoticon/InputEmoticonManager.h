//
//  InputEmoticonManager.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/5.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputEmoticon : NSObject
@property (nonatomic, strong) NSString *emoticonID;//图片类型名字
@property (nonatomic, strong) NSString *tag;//图片备注，在输入框加载的文字
@property (nonatomic, strong) NSString *filename;//图片名
@end

@interface InputEmoticonLayout : NSObject
@property (nonatomic, assign) NSInteger rows;               //行数
@property (nonatomic, assign) NSInteger columes;            //列数
@property (nonatomic, assign) NSInteger itemCountInPage;    //每页显示几项
@property (nonatomic, assign) CGFloat   cellWidth;          //单个单元格宽
@property (nonatomic, assign) CGFloat   cellHeight;         //单个单元格高
@property (nonatomic, assign) CGFloat   imageWidth;         //显示图的宽
@property (nonatomic, assign) CGFloat   imageHeight;        //显示图片的高
@property (nonatomic, assign) BOOL      emoji;

- (id)initEmojiLayout:(CGFloat)width;

- (id)initCharletLayout:(CGFloat)width;
@end

@interface InputEmoticonCatalog : NSObject
@property (nonatomic, strong)   InputEmoticonLayout *layout;
@property (nonatomic, strong)   NSString            *catalogID;
@property (nonatomic, strong)   NSString            *title;
@property (nonatomic, strong)   NSDictionary        *id2Emoticons;
@property (nonatomic, strong)   NSDictionary        *tag2Emoticons;
@property (nonatomic, strong)   NSArray             *emoticons;
@property (nonatomic, strong)   NSString            *icon;          //图标
@property (nonatomic, strong)   NSString            *iconPressed;    //小图标按下效果
@property (nonatomic, assign)   NSInteger           pagesCount;     //分页数
@end
@interface InputEmoticonManager : NSObject

+ (instancetype)sharedManager;

- (InputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID;
- (InputEmoticon *)emoticonByTag:(NSString *)tag;
- (InputEmoticon *)emoticonByID:(NSString *)emoticonID;
- (InputEmoticon *)emoticonByCatalogID:(NSString *)catalogID
                      emoticonID:(NSString *)emoticonID;

- (NSArray *)loadChartletEmoticonCatalog;
@end
