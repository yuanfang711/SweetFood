//
//  GoodTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodTableViewCell (){
    CGRect rect;
}
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *introl;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *neme;

@end

@implementation GoodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self get];
    }
    return self;
}

- (void)get{
    
//    self.icon.backgroundColor = [UIColor cyanColor];
//    self.introl.backgroundColor = [UIColor magentaColor];
//    self.neme.backgroundColor = [UIColor grayColor];
//    self.title.backgroundColor = [UIColor orangeColor];
    self.title.textColor = [UIColor whiteColor];
    self.neme.textColor = [UIColor whiteColor];
    
    [self addSubview:self.icon];
    [self addSubview:self.title];
    [self addSubview:self.neme];
    
    [self addSubview:self.introl];
}



//获取整个cell的高度  = 图片 加  介绍的label的高度
+(CGFloat )getCellHeightWithGoodModel:(GoodModel *)model{
    CGFloat textHeight = [[self class] getTextHeightWithText:model.introl];
    
    return (textHeight + 225);
}

//获取cell中introduce的高度
+ (CGFloat)getTextHeightWithText:(NSString *)introl{
    
    CGRect rect = [introl boundingRectWithSize:CGSizeMake(kScreenWitch - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
}


- (void)setGoodModel:(GoodModel *)goodModel{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodModel.ImageView] placeholderImage:nil];
    self.title.text = goodModel.title;
    self.neme.text = goodModel.nema;
    self.introl.text = goodModel.introl;
    CGFloat heaght = [[self class]getTextHeightWithText:goodModel.introl];
    CGRect frame = self.introl.frame;
    frame.size.height = heaght;
    self.introl.frame = frame;
}

- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, kScreenWitch - 40, 210)];
    }
    return _icon;
}

- (UILabel *)introl{
    if (_introl == nil) {
        _introl = [[UILabel alloc] initWithFrame:CGRectMake(20, 225, kScreenWitch - 40, 40)];
        self.introl.numberOfLines = 0;
        self.introl.font = [UIFont systemFontOfSize:15.0];
    }
    return _introl;
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 200, 30)];
    }
    return _title;
}


- (UILabel *)neme{
    if (_neme == nil) {
        _neme = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, 200, 20)];
        self.neme.font = [UIFont systemFontOfSize:15.0];
    }
    return _neme;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
