//
//  MineHeaderTableCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/24.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "MineHeaderTableCell.h"
@interface MineHeaderTableCell()
@property (nonatomic, strong) UIImageView *setUpImageView;//设置
@property (nonatomic, strong) UILabel *nameLabel;//昵称
@property (nonatomic, strong) UILabel *goldLabel;//金币
@property (nonatomic, strong) UILabel *coinLabel;//战旗币
@property (nonatomic, strong)UIImageView *headerImageView;//头像
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
- (void)personal:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectInfoButton:)]) {
        [self.delegate didSelectInfoButton:tap.view.tag];
    }
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.setUpImageView.frame), 68, 68)];
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
        _setUpImageView.frame = CGRectMake(kScreen_width-20-20, 40, 20, 20);
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
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+20, CGRectGetMinY(self.headerImageView.frame)+10, kScreen_width-20-20-CGRectGetMaxX(self.headerImageView.frame), 25)];
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
        _goldLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame)-15, CGRectGetMaxY(self.headerImageView.frame)-30, 68, 30)];
        
        _goldLabel.textAlignment = NSTextAlignmentCenter;
        
        _goldLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        _goldLabel.numberOfLines = 0;

        UILabel *goldStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_goldLabel.frame), CGRectGetMaxY(_goldLabel.frame), CGRectGetWidth(_goldLabel.frame), 20)];
        goldStringLabel.textAlignment = NSTextAlignmentCenter;
        goldStringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        goldStringLabel.textColor = [UIColor lightGrayColor];
        goldStringLabel.text = @"金币";
        
        [self addSubview:goldStringLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_goldLabel.frame)+5, CGRectGetMinY(_goldLabel.frame), 0.5, CGRectGetHeight(goldStringLabel.frame)+ CGRectGetHeight(_goldLabel.frame))];
        
        line.backgroundColor = tableViewBackGroundColor;
        
        [self addSubview:line];
    }
    return _goldLabel;
}
- (UILabel *)coinLabel
{
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goldLabel.frame)+10, CGRectGetMinY(self.goldLabel.frame), CGRectGetWidth(self.goldLabel.frame), CGRectGetHeight(self.goldLabel.frame))];
        
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        
        _coinLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        _coinLabel.numberOfLines = 0;
        
        UILabel *coinStringLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_coinLabel.frame), CGRectGetMaxY(_coinLabel.frame), CGRectGetWidth(_coinLabel.frame), 20)];
        coinStringLabel.textAlignment = NSTextAlignmentCenter;
        coinStringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        coinStringLabel.textColor = [UIColor lightGrayColor];
        coinStringLabel.text = @"战旗币";
        
        [self addSubview:coinStringLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_coinLabel.frame)+5, CGRectGetMinY(_coinLabel.frame), 0.5, CGRectGetHeight(_coinLabel.frame)+CGRectGetHeight(coinStringLabel.frame))];
        
        line.backgroundColor = tableViewBackGroundColor;
        
        [self addSubview:line];
    }
    return _coinLabel;
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
    CGFloat labelHeight = (CGRectGetHeight(self.coinLabel.frame)+20)/2;
    UILabel *topupLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width-60, CGRectGetMinY(self.coinLabel.frame)+10, 40, labelHeight)];
    topupLabel.userInteractionEnabled = YES;
    topupLabel.text = @"充值";
    topupLabel.textColor = navigationBarColor;
    topupLabel.tag = 3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personal:)];
    [topupLabel addGestureRecognizer:tap];
    
    [self addSubview:topupLabel];
}
- (void)loginOutRemoveView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == 3) {
                [button removeFromSuperview];
            }
        }
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
