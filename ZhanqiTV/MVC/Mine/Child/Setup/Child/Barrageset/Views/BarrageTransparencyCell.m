//
//  BarrageTransparencyCell.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/17.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "BarrageTransparencyCell.h"

@interface BarrageTransparencyCell()
@property (nonatomic, strong) UILabel *label;//标题
@property (nonatomic, strong) UILabel *transparencyLabel;//透明度数值
@property (nonatomic, strong) UISlider *slider;//
@end
@implementation BarrageTransparencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    [self setup];
    return self;
}
- (void)setup
{
    [self addSubview:self.label];
    [self addSubview:self.transparencyLabel];
    [self addSubview:self.slider];
    self.transparencyLabel.text = [NSString stringWithFormat:@"%.f％",[self.slider value]];
}
//TODO:懒加载
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, kScreen_width/2-12, 25)];
        _label.text = @"弹幕透明度";
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _label;
}
- (UILabel *)transparencyLabel
{
    if (!_transparencyLabel) {
        _transparencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_width/2+10, viewY(self.label), kScreen_width/2-22, viewHeight(self.label))];
        _transparencyLabel.textAlignment = NSTextAlignmentRight;
        _transparencyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _transparencyLabel;
}
- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(viewX(self.label),50, kScreen_width-20, 40)];
        _slider.maximumValue = 100;
        _slider.minimumValue = 0;
        _slider.value = 100;
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
- (void)sliderAction:(UISlider *)slider
{
    self.transparencyLabel.text = [NSString stringWithFormat:@"%.f％",[slider value]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
