//
//  StepsTableViewCell.m
//  SweetFood
//
//  Created by scjy on 16/4/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "StepsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface StepsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imagesView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation StepsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setModel:(StepsModel *)model{
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:model.StepPhoto] placeholderImage:nil];
    self.title.text = model.Intro;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
