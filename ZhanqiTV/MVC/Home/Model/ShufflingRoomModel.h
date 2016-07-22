//
//  ShufflingRoomModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol IsStar
@end
@interface IsStar : JSONModel
@property (nonatomic, strong) NSString<Optional> *isWeek;
@property (nonatomic, strong) NSString<Optional> *isMonth;
@end

@protocol Room
@end
@interface Room : JSONModel
@property (nonatomic, strong) NSString<Optional> *roomNotice;
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *gameName;
@property (nonatomic, strong) NSString<Optional> *hotsLevel;
@property (nonatomic, strong) NSString<Optional> *gameUrl;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *fans;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *gameId;
@property (nonatomic, strong) NSString<Optional> *allowVideo;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *gameIcon;
@property (nonatomic, strong) NSString<Optional> *addTime;
@property (nonatomic, strong) NSString<Optional> *gameBpic;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *template;
@property (nonatomic, strong) NSString<Optional> *videoId;
@property (nonatomic, strong) NSString<Optional> *chatStatus;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *domain;
@property (nonatomic, strong) NSString<Optional> *editTime;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *online;
@property (nonatomic, strong) NSString<Optional> *liveTime;
@property (nonatomic, strong) NSString<Optional> *allowRecord;
@property (nonatomic, strong) NSString<Optional> *videoIdKey;
@property (nonatomic, strong) NSString<Optional> *roomCoverType;
@property (nonatomic, strong) NSString<Optional> *bonus;
@property (nonatomic, strong) NSString<Optional> *publishUrl;
@property (nonatomic, strong) NSString<Optional> *anchorNotice;
@property (nonatomic, strong) NSString<Optional> *follows;
@property (nonatomic, strong) NSString<Optional> *gender;
@property (nonatomic, strong) NSString<Optional> *roomCover;
@property (nonatomic, strong) id<Optional> translateLanguages;
@property (nonatomic, strong) IsStar<Optional> *isStar;
@property (nonatomic, strong) NSString<Optional> *fansTitle;
@property (nonatomic, strong) NSString<Optional> *verscr;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) NSString<Optional> *spic;
@end

@protocol ShufflingRoomModel
@end
@interface ShufflingRoomModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *position;
@property (nonatomic, strong) NSString<Optional> *gameId;
@property (nonatomic, strong) NSString<Optional> *positionType;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *chnId;
@property (nonatomic, strong) NSString<Optional> *roomId;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) Room<Optional> *room;
@property (nonatomic, strong) NSString<Optional> *contents;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *matchId;
@end

@interface ShufflingSuperRoomModel : JSONModel
@property (nonatomic, strong) NSArray<Optional,ShufflingRoomModel> *data;
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSArray<Optional> *ads;
@end
