//
//  InputEmoticonManager.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/5.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "InputEmoticonManager.h"
#import "InputEmoticonDefine.h"
#import "UIImage+YZY.h"
#import "NSString+Input.h"
@implementation InputEmoticon
@end

@implementation InputEmoticonCatalog
@end

@implementation InputEmoticonLayout

- (id)initEmojiLayout:(CGFloat)width
{
    self = [super init];
    if (self) {
        _rows               = EmojRows;
        _columes            = ((width - EmojiLeftMargin - EmojiRightMargin) / EmojImageWidth);
        _itemCountInPage    = _rows * _columes - 1;
        _cellWidth          = (width - EmojiLeftMargin - EmojiRightMargin) / _columes;
        _cellHeight         = EmojCellHeight;
        _imageWidth         = EmojImageWidth;
        _imageHeight        = EmojImageHeight;
        _emoji              = YES;
    }
    return self;
}

- (id)initCharletLayout:(CGFloat)width
{
    self = [super init];
    if (self) {
        _rows            = PicRows;
        _columes         = ((width - EmojiLeftMargin - EmojiRightMargin) / PicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - EmojiLeftMargin - EmojiRightMargin) / _columes;
        _cellHeight      = PicCellHeight;
        _imageWidth      = PicImageWidth;
        _imageHeight     = PicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end

@interface InputEmoticonManager()
@property (nonatomic, strong) NSArray *catalogs;

@end
@implementation InputEmoticonManager
+ (instancetype)sharedManager
{
    static InputEmoticonManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[InputEmoticonManager alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self parsePlist];
    }
    return self;
}
- (InputEmoticonCatalog *)emoticonCatalog:(NSString *)catalogID
{
    for (InputEmoticonCatalog *catalog in _catalogs) {
        if ([catalog.catalogID isEqualToString:catalogID]) {
            return catalog;
        }
    }
    return nil;
}
- (InputEmoticon *)emoticonByCatalogID:(NSString *)catalogID emoticonID:(NSString *)emoticonID
{
    InputEmoticon *emoticon = nil;
    
    if (catalogID.length && emoticonID.length) {
        for (InputEmoticonCatalog *catalog in _catalogs) {
            if ([catalog.catalogID isEqualToString:catalogID]) {
                emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
                break;
            }
        }
    }
    return emoticon;
}

- (InputEmoticon *)emoticonByID:(NSString *)emoticonID
{
    InputEmoticon *emoticon = nil;
    if (emoticonID.length) {
        for (InputEmoticonCatalog *catalog in _catalogs) {
            emoticon = [catalog.id2Emoticons objectForKey:emoticonID];
            if (emoticon) {
                break;
            }
        }
    }
    return emoticon;
}

- (InputEmoticon *)emoticonByTag:(NSString *)tag
{
    InputEmoticon *emoticon = nil;
    if (tag.length) {
        for (InputEmoticonCatalog *catalog in _catalogs) {
            emoticon = [catalog.tag2Emoticons objectForKey:tag];
            if (emoticon) {
                break;
            }
        }
    }
    return emoticon;
}

- (NSArray *)loadChartletEmoticonCatalog//加载贴图
{
    NSString *directory = [EmoticonPath stringByAppendingPathComponent:ChartletChartletCatalogPath];
    NSURL *url = [[NSBundle mainBundle] URLForResource:[self myBundleName] withExtension:nil];
    
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    NSArray *paths = [bundle pathsForResourcesOfType:nil inDirectory:directory];
    
    NSMutableArray *res = [[NSMutableArray alloc]init];
    
    for (NSString *path in paths) {
        BOOL isDirectory = NO;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            InputEmoticonCatalog *catalog = [[InputEmoticonCatalog alloc]init];
            
            catalog.catalogID = path.lastPathComponent;
            NSArray *resources = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:ChartletChartletCatalogContentPath]];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSString *sPath in resources) {
                NSString *name = sPath.lastPathComponent.stringByDeletingPathExtension;
                
                InputEmoticon *icon = [[InputEmoticon alloc]init];
                icon.emoticonID = name.stringByDeletingPictureResolution;
                icon.filename = sPath;
                [array addObject:icon];
            }
            catalog.emoticons = array;
            
            NSArray *icons = [NSBundle pathsForResourcesOfType:nil inDirectory:[path stringByAppendingPathComponent:ChartletChartletCatalogIconPath]];
            
            for (NSString *path in icons) {
                NSString *name = path.lastPathComponent.stringByDeletingPathExtension.stringByDeletingPictureResolution;
                if ([name hasSuffix:ChartletChartletCatalogIconsSuffixNormal]) {
                    catalog.icon = path;
                }
                else if ([name hasSuffix:ChartletChartletCatalogIconsSuffixHighLight])
                {
                    catalog.iconPressed = path;
                }
            }
            [res addObject:catalog];
        }
    }
    
    return res;
}
- (NSString *)myBundleName
{
    return InputBundleName;
}
- (void)parsePlist
{
    NSMutableArray *catalogs = [NSMutableArray array];
    
    NSString *directory = [EmoticonPath stringByAppendingPathComponent:EmojiPath];
    NSURL *url = [[NSBundle mainBundle] URLForResource:[self myBundleName] withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    NSString *filepath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:directory];
    if (filepath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        for (NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSArray *emoticons = dict[@"data"];
            
            InputEmoticonCatalog *catalog = [self catalogByInfo:info
                                                         emoticons:emoticons];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}
//
- (InputEmoticonCatalog *)catalogByInfo:(NSDictionary *)info
                              emoticons:(NSArray *)emoticonsArray
{
    InputEmoticonCatalog *catalog = [[InputEmoticonCatalog alloc]init];
    catalog.catalogID           = info[@"id"];
    catalog.title               = info[@"title"];
    
    NSString *iconNamePrefix = [[[self myBundleName] stringByAppendingPathComponent:EmoticonPath] stringByAppendingPathComponent:EmojiPath];
    NSString *icon                = info[@"normal"];
    catalog.icon = [iconNamePrefix stringByAppendingPathComponent:icon];
    
    NSString *iconPressed         = info[@"pressed"];
    
    catalog.iconPressed = [iconNamePrefix stringByAppendingPathComponent:iconPressed];
    NSMutableDictionary *tag2Emoticons = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2Emoticons = [NSMutableDictionary dictionary];
    NSMutableArray *emoticons = [NSMutableArray array];
    
    for (NSDictionary *emoticonDict in emoticonsArray) {
        InputEmoticon *emoticon  = [[InputEmoticon alloc] init];
        emoticon.emoticonID     = emoticonDict[@"id"];
        emoticon.tag            = emoticonDict[@"tag"];
        NSString *filename      = emoticonDict[@"file"];
        
        NSString *imageNamePrefix = [[[self myBundleName] stringByAppendingPathComponent:EmoticonPath] stringByAppendingPathComponent:EmojiPath];
        
        emoticon.filename = [imageNamePrefix stringByAppendingPathComponent:filename];
        
        if (emoticon.emoticonID) {
            [emoticons addObject:emoticon];
            id2Emoticons[emoticon.emoticonID] = emoticon;
        }
        if (emoticon.tag) {
            tag2Emoticons[emoticon.tag] = emoticon;
        }
    }
    
    catalog.emoticons       = emoticons;
    catalog.id2Emoticons    = id2Emoticons;
    catalog.tag2Emoticons   = tag2Emoticons;
    return catalog;
}
@end
