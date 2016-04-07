//
//  MainTableViewCell.h
//  SweetFood
//
//  Created by scjy on 16/4/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MianModel.h"
#import "MainModel.h"
@interface MainTableViewCell : UITableViewCell

@property (nonatomic, strong) MianModel *model;
@property (nonatomic, strong) MainModel *mainModel;
@end
