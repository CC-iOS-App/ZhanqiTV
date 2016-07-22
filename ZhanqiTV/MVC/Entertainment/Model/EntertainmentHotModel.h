//
//  EntertainmentHotModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/19.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol EntertainmentHotRoomRooms
@end
@interface EntertainmentHotRoomRooms : JSONModel
@property (nonatomic, strong) NSString<Optional> *verscr;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *gameName;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *positionType;
@property (nonatomic, strong) NSString<Optional> *gameId;
@property (nonatomic, strong) NSString<Optional> *hotsLevel;
@property (nonatomic, strong) NSString<Optional> *liveTime;
@property (nonatomic, strong) NSString<Optional> *domain;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *gender;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *fireworks;
@property (nonatomic, strong) NSString<Optional> *videoId;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *gameUrl;
@property (nonatomic, strong) NSString<Optional> *fireworksHtml;
@property (nonatomic, strong) NSString<Optional> *gameIcon;
@property (nonatomic, strong) NSString<Optional> *highlight;
@property (nonatomic, strong) NSString<Optional> *online;
@end

@protocol EntertainmentHotRoom
@end
@interface EntertainmentHotRoom : JSONModel
@property (nonatomic, strong) NSArray<Optional,EntertainmentHotRoomRooms> *rooms;
@property (nonatomic, strong) NSString<Optional> *cnt;
@end

@protocol EntertainmentBannerFlashvars
@end
@interface EntertainmentBannerFlashvars : JSONModel
@property (nonatomic, strong) NSArray<Optional> *ServerIp;
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
@property (nonatomic, strong) NSArray<Optional> *ServerPort;
@property (nonatomic, strong) NSString<Optional> *VideoType;
@property (nonatomic, strong) NSString<Optional> *Online;
@property (nonatomic, strong) NSString<Optional> *Status;
@property (nonatomic, strong) NSString<Optional> *Oversee2;
@end


@protocol EntertainmentBanner
@end
@interface EntertainmentBanner : JSONModel
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *nickname;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *gameId;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *liveTime;
@property (nonatomic, strong) NSString<Optional> *domain;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *gender;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *hotsLevel;
@property (nonatomic, strong) NSString<Optional> *videoId;
@property (nonatomic, strong) EntertainmentBannerFlashvars<Optional> *flashvars;
@property (nonatomic, strong) NSString<Optional> *videoIdKey;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *publishUrl;
@property (nonatomic, strong) NSString<Optional> *online;
@property (nonatomic, strong) NSString<Optional> *verscr;
@end

@protocol EntertainmentHotModel
@end
@interface EntertainmentHotModel : JSONModel
@property (nonatomic, strong) NSArray<Optional,EntertainmentBanner> *banner;
@property (nonatomic, strong) EntertainmentHotRoom<Optional> *hotRoom;
@end

@interface EntertainmentHotSuperModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) EntertainmentHotModel<Optional> *data;
@property (nonatomic, strong) NSString<Optional> *code;
@end
