//
//  GoodTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodTableViewCell.h"

@interface GoodTableViewCell ()
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

//- (void)setMenuModel:(MenuModel *)menuModel{
//    //    [self.icon sd_setImageWithURL:[NSURL URLWithString:menuModel.icin] placeholderImage:nil];
//    //    self.introl.text = menuModel.introl;
//
//}

- (void)setGoodModel:(GoodModel *)goodModel{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:goodModel.ImageView] placeholderImage:nil];
    self.introl.text = goodModel.introl;
    self.title.text = goodModel.title;
    self.neme.text = goodModel.nema;
}

- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, kScreenWitch - 40, 210)];
    }
    return _icon;
}

- (UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 200, 30)];
    }
    return _title;
}

- (UILabel *)neme{
    if (_neme == nil) {
        _neme = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 200, 20)];
        self.neme.font = [UIFont systemFontOfSize:15.0];
    }
    return _neme;
}

- (UILabel *)introl{
    if (_introl == nil) {
        _introl = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, kScreenWitch - 20, 20)];
    }
    return _introl;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
