//
//  CommonTableData.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/29.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "CommonTableData.h"

#define DefaultUIRowHeight 44.f
#define DefaultUIHeaderHeight 15.f
#define DefaultUIFooterHeight .1f
@implementation CommonTableSection
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if ([dict[Disable] boolValue]) {//如果不可见
        return nil;
    }
    self = [super init];
    if (self) {
        _headerTitle = dict[HeaderTitle] ? dict[HeaderTitle] : @"";
        _footerTitle = dict[FooterTitle] ? dict[FooterTitle] : @"";
        _uiFooterHeight = [dict[FooterHeight] floatValue];
        _uiHeaderHeight = [dict[HeaderHeight] floatValue];
        _uiHeaderHeight = _uiHeaderHeight ? _uiHeaderHeight : DefaultUIHeaderHeight;
        _uiFooterHeight = _uiFooterHeight ? _uiFooterHeight : DefaultUIFooterHeight;
        _rows = [CommonTableRow rowsWithData:dict[RowContent]];
    }
    return self;
}
+ (NSArray *)sectionWithData:(NSArray *)data
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:data.count];
    
//    for (NSDictionary *dict in data) {  原本是这个，我感觉下面安全判断的话这里应该为id
    for (id dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            CommonTableSection *section = [[CommonTableSection alloc]initWithDict:(NSDictionary *)dict];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}
@end


@implementation CommonTableRow

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if ([dict[Disable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _title = dict[Title];
        _detailTitle = dict[DetailTitle];
        _imageName = dict[Image];
        _cellClassName = dict[CellClass];
        _cellActionName = dict[CellAction];
        _uiRowHeight = dict[RowHeight] ? [dict[RowHeight] floatValue] : DefaultUIRowHeight;
        _extraInfo = dict[ExtraInfo];
        _sepLeftEdge = [dict[SepLeftEdge] floatValue];
        _showAccessory = [dict[ShowAccessory] boolValue];
        _forbidSelect = [dict[ForbidSelect] boolValue];
        _disSelected = [dict[DisSelected] boolValue];
        
    }
    return self;
}
+ (NSArray *)rowsWithData:(NSArray *)data
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:data.count];
    
    for (id dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            CommonTableRow *row = [[CommonTableRow alloc]initWithDict:(NSDictionary *)dict];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}
@end