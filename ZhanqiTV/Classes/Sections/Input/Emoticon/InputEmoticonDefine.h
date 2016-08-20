//
//  InputEmoticonDefine.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/8/4.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#ifndef InputEmoticonDefine_h
#define InputEmoticonDefine_h

#define InputBundleName         @"InputResouce.bundle"
#define EmojiCatalog                                @"default"
#define EmoticonPath                                @"Emoticon"
#define EmojiPath                                   @"Emoji"
#define ChartletChartletCatalogPath                 @"Chartlet"
#define ChartletChartletCatalogContentPath          @"content"
#define ChartletChartletCatalogIconPath             @"icon"
#define ChartletChartletCatalogIconsSuffixNormal    @"normal"
#define ChartletChartletCatalogIconsSuffixHighLight @"highlighted"

#define EmojiLeftMargin      8
#define EmojiRightMargin     8
#define EmojiTopMargin       14
#define DeleteIconWidth      43.0
#define DeleteIconHeight     43.0
#define EmojCellHeight       46.0
#define EmojImageHeight      43.0
#define EmojImageWidth       43.0
#define EmojRows             3

//贴图
#define PicCellHeight        76.0
#define PicImageHeight       70.f
#define PicImageWidth        70.f
#define PicRows              2


#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#endif /* InputEmoticonDefine_h */
