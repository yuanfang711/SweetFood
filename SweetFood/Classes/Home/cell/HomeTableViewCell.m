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


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingS];
    }
    return self;
}
- (void)settingS{
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    
    self.iconView.layer.cornerRadius = 15;
    self.iconView.clipsToBounds = YES;
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 30)];


    self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWitch - 80, 5, 80, 30)];
    
    
    self.imageViewS = [[UIImageView alloc] initWithFrame:CGRectMake(5, 38,kScreenWitch - 10 , 185)];
    
    self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, kScreenWitch - 20, 30)];
    self.nameL.textColor = [UIColor whiteColor];
    
    self.nameL.font = [UIFont systemFontOfSize:17.0];

    self.introL = [[UILabel alloc] initWithFrame:CGRectMake(20, 195, kScreenWitch - 20, 25)];
    
    self.introL.textColor = [UIColor whiteColor];
    
    self.introL.font = [UIFont systemFontOfSize:15.0];

    
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



//- (UIImageView *)iconView{
//    if (_iconView == nil) {
//       
//    }
//    return _iconView;
//}
//- (UILabel *)titleL{
//    if (_titleL == nil) {
//       
//    }
//    return _titleL;
//}
//- (UILabel *)priceL{
//    if (_priceL == nil) {
//
//    }
//    return _priceL;
//}
//
//- (UIImageView *)imageViewS{
//    if (_imageViewS == nil) {
//
//    }
//    return _imageViewS;
//}
//
//- (UILabel *)nameL{
//    if (_nameL == nil) {
//    
//    }
//    return _nameL;
//}
//
//- (UILabel *)introL{
//    if (_introL == nil) {
// 
//    }
//    return _introL;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
