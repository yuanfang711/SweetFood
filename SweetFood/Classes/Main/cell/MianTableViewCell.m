//
//  MianTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MianTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MianTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *smallTitle;

@end



@implementation MianTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(MianModel *)model{
    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    
    self.titleLable.text = model.title;
    
    self.smallTitle.text = model.intro;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
