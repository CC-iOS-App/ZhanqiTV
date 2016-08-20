//
//  LiveKindRoomModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol LiveKindFlashvarsServerIp
@end
@interface LiveKindFlashvarsServerIp : JSONModel
@end

@protocol LiveKindFlashvarsServerPort
@end
@interface LiveKindFlashvarsServerPort : JSONModel
@end


@protocol LiveKindFlashvars
@end
@interface LiveKindFlashvars : JSONModel
@property (nonatomic, strong) NSArray<Optional,LiveKindFlashvarsServerIp> *ServerIp;
@property (nonatomic, strong) NSString<Optional> *pv;
@property (nonatomic, strong) NSArray<Optional> *ChatRoomId;
@property (nonatomic, strong) NSString<Optional> *RoomId;
@property (nonatomic, strong) NSString<Optional> *GameId;
@property (nonatomic, strong) NSString<Optional> *VideoLevels;
@property (nonatomic, strong) NSString<Optional> *WebHost;
@property (nonatomic, strong) NSString<Optional> *UseLsIp;
@property (nonatomic, strong) NSString<Optional> *VideoTitle;
@property (nonatomic, strong) NSString<Optional> *Servers;
@property (nonatomic, strong) NSString<Optional> *Zqad;
@property (nonatomic, strong) NSString<Optional> *TuristRate;
@property (nonatomic, strong) NSString<Optional> *ComLayer;
@property (nonatomic, strong) NSString<Optional> *UseStIp;
@property (nonatomic, strong) NSString<Optional> *cdns;
@property (nonatomic, strong) NSArray<Optional,LiveKindFlashvarsServerPort> *ServerPort;
@property (nonatomic, strong) NSString<Optional> *VideoType;
@property (nonatomic, strong) NSString<Optional> *Online;
@property (nonatomic, strong) NSString<Optional> *Status;
@property (nonatomic, strong) NSString<Optional> *Oversee2;
@end

@protocol LiveKindRoomsAnchorAttrHots
@end
@interface LiveKindRoomsAnchorAttrHots : JSONModel
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *fight;
@property (nonatomic, strong) NSString<Optional> *nowLevelStart;
@property (nonatomic, strong) NSString<Optional> *nextLevelFight;
@end

@protocol LiveKindRoomsAnchorAttr
@end
@interface LiveKindRoomsAnchorAttr : JSONModel
@property (nonatomic, strong) NSArray<Optional,LiveKindRoomsAnchorAttrHots> *hots;
@end

@protocol LiveKindRoomsIsStar
@end
@interface LiveKindRoomsIsStar : JSONModel
@property (nonatomic, strong) NSString<Optional> *isWeek;
@property (nonatomic, strong) NSString<Optional> *isMonth;
@end

@protocol LiveKindRoomsPermission
@end
@interface LiveKindRoomsPermission : JSONModel
@property (nonatomic, strong) NSString<Optional> *fans;
@property (nonatomic, strong) NSString<Optional> *guess;
@property (nonatomic, strong) NSString<Optional> *replay;
@property (nonatomic, strong) NSString<Optional> *multi;
@property (nonatomic, strong) NSString<Optional> *shift;
@property (nonatomic, strong) NSString<Optional> *firework;
@end

@protocol LiveKindRooms
@end
@interface LiveKindRooms : JSONModel
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
@property (nonatomic, strong) id<Optional> flashvars;
@property (nonatomic, strong) NSString<Optional> *gameBpic;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) LiveKindRoomsAnchorAttr<Optional> *anchorAttr;
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
@property (nonatomic, strong) LiveKindRoomsIsStar<Optional> *isStar;
@property (nonatomic, strong) NSString<Optional> *rpic;
@property (nonatomic, strong) LiveKindRoomsPermission<Optional> *permission;
@property (nonatomic, strong) NSString<Optional> *fansTitle;
@property (nonatomic, strong) NSString<Optional> *verscr;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) NSString<Optional> *spic;
@end

@protocol LiveKindRoomModel
@end
@interface LiveKindRoomModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *cnt;
@property (nonatomic, strong) NSArray<Optional,LiveKindRooms> *rooms;
@end

@interface LiveKindSuperRoomModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) LiveKindRoomModel<Optional> *data;
@end