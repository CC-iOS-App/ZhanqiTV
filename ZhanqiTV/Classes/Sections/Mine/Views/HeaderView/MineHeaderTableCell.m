//
//  MineHeaderTableCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/24.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MineHeaderTableCell.h"
#import "CommonTableData.h"
#import "CommonTableViewCell.h"
#import "UIView+YZY.h"
#import "SetupViewController.h"
@interface MineHeaderTableCell()<CommonTableViewCell>
@property (nonatomic, strong) UIImageView *setUpImageView;//设置
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *goldLabel;//金币
@property (nonatomic, strong) UILabel *coinLabel;//战旗币
@property (nonatomic, strong) UIImageView *headerImageView;//头像
@property (nonatomic, strong) UILabel *topupLabel;//充值

@property (nonatomic, strong)NSString *gold;//金币
@property (nonatomic, strong)NSString *coin;//战旗币
@property (nonatomic, strong)NSString *name;//昵称

- (void)addLoginedView;
- (void)loginOutRemoveView;
@end
@implementation MineHeaderTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 94)];
        topView.backgroundColor = MineHeaderBackGroundColor;
        
        [self addSubview:topView];
        
        [self addSubview:self.setUpImageView];
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.goldLabel];
        [self addSubview:self.coinLabel];
    }
    return self;
}
- (void)refreshData:(CommonTableRow *)rowData tableView:(UITableView *)tableView
{
    self.textLabel.text = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    self.name = @"路飞";
    self.gold = @"222";
    self.coin = @"333";
    [self addLoginedView];
}
- (void)personal:(UITapGestureRecognizer *)tap
{
        UITableView *tableView = (UITableView *)self.superview;
        switch (tap.view.tag) {
            case 0:
            {
                SetupViewController *vc = [[SetupViewController alloc]init];
                
                vc.title = @"设置";
                [tableView.viewController.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
                NSLog(@"头像");
                break;
            case 2:
                NSLog(@"昵称");
                break;
            case 3:
                NSLog(@"充值");
                break;
            default:
                break;
        }
    
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.setUpImageView.bottom-5, 68, 68)];
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.layer.cornerRadius = 68/2;
        _headerImageView.image = [UIImage imageNamed:@"Mine_HeaderImage"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personal:)];
        _headerImageView.tag = 1;
        [_headerImageView addGestureRecognizer:tap];
    }
    return _headerImageView;
}
- (UIImageView *)setUpImageView
{
    if (!_setUpImageView) {
        _setUpImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Mine_setUp"]];
        _setUpImageView.frame = CGRectMake(kScreen_width-20-25, 40, 25, 25);
        _setUpImageView.tag = 0;
        _setUpImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personal:)];
        
        [_setUpImageView addGestureRecognizer:tap];
    }
    return _setUpImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headerImageView.right+20,self.headerImageView.top+10, kScreen_width-20-20-self.headerImageView.right, 25)];
        _nameLabel.userInteractionEnabled = YES;
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.tag = 2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personal:)];
        [_nameLabel addGestureRecognizer:tap];
    }
    return _nameLabel;
}
- (UILabel *)goldLabel
{
    if (!_goldLabel) {
        _goldLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.left-15,self.headerImageView.bottom-30, 68, 30)];
        
        _goldLabel.textAlignment = NSTextAlignmentCenter;
        
        _goldLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        _goldLabel.numberOfLines = 0;

        UILabel *goldStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goldLabel.left,_goldLabel.bottom, _goldLabel.width, 20)];
        goldStringLabel.textAlignment = NSTextAlignmentCenter;
        goldStringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        goldStringLabel.textColor = [UIColor lightGrayColor];
        goldStringLabel.text = @"金币";
        
        [self addSubview:goldStringLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_goldLabel.right+5,_goldLabel.top, 0.5,goldStringLabel.height+ _goldLabel.height)];
        
        line.backgroundColor = tableViewBackGroundColor;
        
        [self addSubview:line];
    }
    return _goldLabel;
}
- (UILabel *)coinLabel
{
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.goldLabel.right+10,self.goldLabel.top, self.goldLabel.width, self.goldLabel.height)];
        
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        
        _coinLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        _coinLabel.numberOfLines = 0;
        
        UILabel *coinStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(_coinLabel.left, _coinLabel.bottom, _coinLabel.width, 20)];
        coinStringLabel.textAlignment = NSTextAlignmentCenter;
        coinStringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        coinStringLabel.textColor = [UIColor lightGrayColor];
        coinStringLabel.text = @"战旗币";
        
        [self addSubview:coinStringLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_coinLabel.right+5, _coinLabel.top, 0.5, _coinLabel.height+coinStringLabel.height)];
        
        line.backgroundColor = tableViewBackGroundColor;
        
        [self addSubview:line];
    }
    return _coinLabel;
}
- (UILabel *)topupLabel
{
    if (!_topupLabel) {
        CGFloat labelHeight = (self.coinLabel.height+20)/2;
        _topupLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-60,self.coinLabel.top+10, 40, labelHeight)];
        _topupLabel.userInteractionEnabled = YES;
        _topupLabel.text = @"充值";
        _topupLabel.tag = 3;
        _topupLabel.textColor = navigationBarColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personal:)];
        [_topupLabel addGestureRecognizer:tap];
    }
    return _topupLabel;
}
- (void)setGold:(NSString *)gold
{
    _gold = gold;
    
    self.goldLabel.text = _gold;
}
- (void)setCoin:(NSString *)coin
{
    _coin = coin;
    
    self.coinLabel.text = _coin;
}
- (void)setName:(NSString *)name
{
    _name = name;
    
    self.nameLabel.text = _name;
}
- (void)addLoginedView
{
    [self addSubview:self.topupLabel];
}
- (void)loginOutRemoveView
{
    [self.topupLabel removeFromSuperview];
    self.topupLabel = nil;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
