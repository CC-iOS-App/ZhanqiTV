//
//  CommonTableData.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/29.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SepLineLeft 15 //分割线距左边距离

//section key
#define HeaderTitle @"headerTitle"
#define FooterTitle @"footerTitle"
#define HeaderHeight @"headerHeight"
#define FooterHeight @"footerHeight"
#define RowContent @"row"

//row key
#define Title @"title"
#define DetailTitle @"detailTitle"
#define Image @"image"
#define CellClass @"cellClass"
#define CellAction @"cellAction"
#define ExtraInfo @"extraInfo"
#define RowHeight @"rowHeight"
#define SepLeftEdge @"leftEdge"

//common key
#define Disable @"disable" //cell不可见
#define ShowAccessory @"accessory" //cell显示>箭头
#define ForbidSelect @"forbidSelect" //cell不响应select事件
#define DisSelected @"disSelected" //cell 不可选中
@interface CommonTableSection : NSObject

@property (nonatomic, copy) NSString *headerTitle;

@property (nonatomic, copy) NSArray *rows;

@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, assign) CGFloat uiHeaderHeight;

@property (nonatomic, assign) CGFloat uiFooterHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSArray *)sectionWithData:(NSArray *)data;
@end

@interface CommonTableRow : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, copy) NSString *detailTitle;

@property (nonatomic, copy) NSString *cellClassName;

@property (nonatomic, copy) NSString *cellActionName;

@property (nonatomic, assign) CGFloat uiRowHeight;

@property (nonatomic, assign) CGFloat sepLeftEdge;

@property (nonatomic, assign) BOOL showAccessory;

@property (nonatomic, assign) BOOL forbidSelect;

@property (nonatomic, strong) id extraInfo;

@property (nonatomic, assign) BOOL disSelected;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSArray *)rowsWithData:(NSArray *)data;
@end
