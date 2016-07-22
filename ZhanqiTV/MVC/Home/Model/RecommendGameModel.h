//
//  RecommendGameModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/11.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Desc
@end
@interface Desc : JSONModel
@end

@protocol Game
@end
@interface Game : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *gameKey;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *watchs;
@property (nonatomic, strong) Desc<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *fid;
@end

@protocol  RecommendGameModel
@end
@interface RecommendGameModel : JSONModel
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
@property (nonatomic, strong) Game<Optional> *game;
@property (nonatomic, strong) NSString<Optional> *contents;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *matchId;
@end

@interface RecommendSuperGameModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) NSArray<Optional,RecommendGameModel> *data;
@end