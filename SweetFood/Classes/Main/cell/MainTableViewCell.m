//
//  MainTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/4/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end


@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(MianModel *)model{
    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    self.titleLable.text = model.title;
}

-(void)setMainModel:(MainModel *)mainModel{
    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:mainModel.icon] placeholderImage:nil];
    self.titleLable.text = mainModel.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
