//
//  MovieMainTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MovieMainTableViewCell.h"

@implementation MovieMainTableViewCell

- (void)awakeFromNib {
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingCell];
    }
    return self;
}
- (void)settingCell{
    self.nameLable.textColor = [UIColor grayColor];
}
-(void)setModel:(HomeModel *)model{
    [self.ImageView  sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:nil];
    self.nameLable.text = model.name;
    self.timeLable.text = model.time;
    NSString *dting = [NSString stringWithFormat:@"%ld",model.playCount];
    self.playLable.text = dting;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
