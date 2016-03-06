//
//  HomeTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HomeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HomeTableViewCell ()

@property (strong, nonatomic)  UIImageView *iconView;
@property (strong, nonatomic)  UILabel *titleL;
@property (strong, nonatomic)  UILabel *priceL;
@property (strong, nonatomic)  UIImageView *imageViewS;
@property (strong, nonatomic)  UILabel *nameL;
@property (strong, nonatomic)  UILabel *introL;
@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingS];
    }
    return self;
}
- (void)settingS{
    [self addSubview:self.iconView];
    [self addSubview:self.titleL];
    [self addSubview:self.priceL];
    [self addSubview:self.imageViewS];
    [self addSubview:self.nameL];
    [self addSubview:self.introL];
}

- (void)setModel:(HomeModel *)model{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    self.titleL.text = model.title;
    self.priceL.text = model.pricate;
    [self.imageViewS sd_setImageWithURL:[NSURL URLWithString:model.imageSting] placeholderImage:nil];
    self.nameL.text = model.name;
    self.introL.text = model.introduce;
}



- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        self.iconView.backgroundColor = [UIColor redColor];
    }
    return _iconView;
}
- (UILabel *)titleL{
    if (_titleL == nil) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 60, 30)];
        self.titleL.backgroundColor = [UIColor cyanColor];
    }
    return _titleL;
}
- (UILabel *)priceL{
    if (_priceL == nil) {
        _priceL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch - 80, 5, 50, 30)];
        self.priceL.backgroundColor = [UIColor grayColor];
    }
    return _priceL;
}

- (UIImageView *)imageViewS{
    if (_imageViewS == nil) {
        _imageViewS = [[UIImageView alloc] initWithFrame:CGRectMake(5, 38,kScreenWitch - 10 , 185)];
        self.imageViewS.backgroundColor = [UIColor blackColor];
    }
    return _imageViewS;
}

- (UILabel *)nameL{
    if (_nameL == nil) {
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 165, kScreenWitch - 20, 30)];
        self.nameL.font = [UIFont systemFontOfSize:17.0];
        self.nameL.backgroundColor = [UIColor grayColor];
    }
    return _nameL;
}

- (UILabel *)introL{
    if (_introL == nil) {
        _introL = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, kScreenWitch - 20, 25)];
        self.introL.font = [UIFont systemFontOfSize:15.0];
        self.introL.backgroundColor = [UIColor magentaColor];
    }
    return _introL;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
