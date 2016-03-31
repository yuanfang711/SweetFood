//
//  MovieMainTableViewCell.h
//  SweetFood
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface MovieMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *playLable;

@property (nonatomic, strong) HomeModel *model;
@end
