//
//  GameKindGamesModel.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/15.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GameKindDesc
@end
@interface GameKindDesc : JSONModel
@end

@protocol GameKindGames
@end
@interface GameKindGames : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *fid;
@property (nonatomic, strong) NSString<Optional> *gameKey;
@property (nonatomic, strong) NSString<Optional> *bpic;
@property (nonatomic, strong) NSString<Optional> *watchs;
@property (nonatomic, strong) GameKindDesc<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *weight;
@property (nonatomic, strong) NSString<Optional> *spic;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *status;
@end

@protocol GameKindGamesModel
@end
@interface GameKindGamesModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *cnt;
@property (nonatomic, strong) NSArray<Optional,GameKindGames> *games;
@end

@interface GameKindSuperGamesModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) GameKindGamesModel<Optional> *data;
@property (nonatomic, strong) NSString<Optional> *code;
@end
