//
//  HomeGameKindView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeGameKindCell.h"
#import "HomeGameKindButtonView.h"
@interface HomeGameKindCell()
{
    RecommendSuperGameModel *_superGameModel;//用来存储传进来的数据
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end
@implementation HomeGameKindCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
//    _homeGameKindArray = [[NSMutableArray alloc]init];
    [self addSubview:self.scrollView];
    [self addSubview:self.rightImageView];
}
//懒加载
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_gameKindRightButton"]];
        _rightImageView.frame = CGRectMake(viewWidth(self.scrollView), 0, 30, viewHeight(self.scrollView));
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.tag = 200;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gameKindAction:)];
        [_rightImageView addGestureRecognizer:tap];
        
    }
    return _rightImageView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width-30, 85*kScreenFactor)];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight(self.scrollView), kScreen_width, 5)];
        line.backgroundColor = tableViewBackGroundColor;
        [self addSubview:line];
    }
    return _scrollView;
}
//设置数据
- (void)resetArray:(RecommendSuperGameModel *)model
{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    _superGameModel = model;
    CGFloat viewWidth = (kScreen_width - 10)/4;
    self.scrollView.contentSize = CGSizeMake(viewWidth*model.data.count, viewHeight(self.scrollView));
    for (int i = 0; i < model.data.count; i++) {
        RecommendGameModel *gameModel = ((RecommendGameModel *)model.data[i]);
        
//        [_homeGameKindArray addObject:gameModel];
        HomeGameKindButtonView *gameButtonView = [[HomeGameKindButtonView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, viewHeight(self.scrollView))];
        
        NSString *urlString;
        if (![gameModel.spic isEqualToString:@""]) {
            urlString = gameModel.spic;
        }
        else
        {
            urlString = gameModel.bpic;
        }
        gameButtonView.imageName = urlString;
        gameButtonView.name = gameModel.title;
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gameKindAction:)];
        gameButtonView.tag = i;
        [gameButtonView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:gameButtonView];
    }
}
- (void)gameKindAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 200) {
        GameKindViewController *vc = [[GameKindViewController alloc]init];
        [_viewController.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LiveKindViewController *vc = [[LiveKindViewController alloc]init];
        RecommendGameModel *model = (RecommendGameModel *)_superGameModel.data[tap.view.tag];
        
        vc.liveKind = @"game";
        vc.channelId = model.gameId;
        vc.title = model.title;
        
        [_viewController.navigationController pushViewController:vc animated:YES];
    }
}
@end
