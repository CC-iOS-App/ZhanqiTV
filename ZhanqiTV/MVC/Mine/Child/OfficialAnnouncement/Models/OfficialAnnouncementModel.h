//
//  OfficialAnnouncementModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol OfficialAnnouncementNewsModel
@end
@interface OfficialAnnouncementNewsModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *brief;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *tag;
@property (nonatomic, strong) NSString<Optional> *dateline;
@property (nonatomic, strong) NSString<Optional> *subCnf;
@property (nonatomic, strong) NSString<Optional> *editTime;
@property (nonatomic, strong) NSString<Optional> *typeName;
@property (nonatomic, strong) NSString<Optional> *content;
@end

@protocol OfficialAnnouncementModel
@end
@interface OfficialAnnouncementModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *cnt;
@property (nonatomic, strong) NSArray<Optional,OfficialAnnouncementNewsModel> *news;
@end

@interface OfficialAnnouncementSuperModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) OfficialAnnouncementModel<Optional> *data;
@end
