//
//  ChuTableViewCell.h
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuModer.h"
@interface ChuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *introL;

@property (nonatomic, strong) ChuModer *model;

@end
