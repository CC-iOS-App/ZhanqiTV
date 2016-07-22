//
//  HomeGameKindButtonView.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/14.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HomeGameKindButtonView.h"
@interface HomeGameKindButtonView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end
@implementation HomeGameKindButtonView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10,self.frame.size.height-40, self.frame.size.height-40)];
    }
    return _imageView;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+10, self.frame.size.width, 10)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    }
    return _label;
}
- (void)setName:(NSString *)name
{
    _name = name;
    self.label.text = _name;
    
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:[UIImage imageNamed:@"default_image"]];
}
@end
