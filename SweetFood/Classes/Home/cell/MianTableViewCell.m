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


@end
@implementation MianTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self seteing];
    }
    return self;
}
- (void)seteing{
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.cellImage];
    [self addSubview:self.titleLable];
}
- (UIImageView *)cellImage{
    if (_cellImage == nil) {
        _cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kScreenWitch -20, kScreenhight/3-10)];
        
    }
    return _cellImage;
}

- (UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenhight/3 - 30, kScreenWitch -20, 20)];
    }
    return _titleLable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
