//
//  ChuTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ChuTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ChuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ChuModer *)model{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.iconView] placeholderImage:nil];
    self.titleL.text = model.title;
    self.dateL.text = model.date;
    self.introL.text = model.intro;
}


- (void)setMModel:(LoveModel *)mModel{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:mModel.iconView] placeholderImage:nil];
    self.titleL.text = mModel.title;
    self.dateL.text = mModel.date;
    self.introL.text = mModel.intro;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
