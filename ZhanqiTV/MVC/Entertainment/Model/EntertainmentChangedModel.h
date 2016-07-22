//
//  EntertainmentChangedModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol EntertainmentChangedRooms
@end
@interface EntertainmentChangedRooms : JSONModel
@property (nonatomic, strong) NSString<Optional> *verscr;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *gameName;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *positionType;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *gameId;
@property (nonatomic, strong) NSString<Optional> *fireworks;
@property (nonatomic, strong) NSString<Optional> *liveTime;
@property (nonatomic, strong) NSString<Optional> *domain;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *gender;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *hotsLevel;
@property (nonatomic, strong) NSString<Optional> *videoId;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *gameUrl;
@property (nonatomic, strong) NSString<Optional> *fireworksHtml;
@property (nonatomic, strong) NSString<Optional> *gameIcon;
@property (nonatomic, strong) NSString<Optional> *online;
@property (nonatomic, strong) NSString<Optional> *highlight;
@end

@protocol EntertainmentChangedModel
@end
@interface EntertainmentChangedModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *cnt;
@property (nonatomic, strong) NSArray<Optional,EntertainmentChangedRooms> *rooms;
@end

@interface EntertainmentChangedSuperModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) EntertainmentChangedModel<Optional> *data;
@property (nonatomic, strong) NSString<Optional> *code;
@end
