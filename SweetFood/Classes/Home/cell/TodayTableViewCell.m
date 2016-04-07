//
//  TodayTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "TodayTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface TodayTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *agoPriceL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *haveL;

@end

@implementation TodayTableViewCell
- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(TodayModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    self.titleL.text = model.title;
    self.agoPriceL.text = model.agoP;
    self.priceL.text = model.price;
    self.haveL.text = model.haveM;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
