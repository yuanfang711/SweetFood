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
    
    self.icon.backgroundColor = [UIColor cyanColor];
    
    self.introl.backgroundColor = [UIColor magentaColor];
    
    [self addSubview:self.icon];
    [self addSubview:self.introl];
}

- (void)setMenuModel:(MenuModel *)menuModel{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:menuModel.icin] placeholderImage:nil];
    self.introl.text = menuModel.introl;
    

    
}



- (UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kScreenWitch - 20, 200)];
    }
    return _icon;
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
