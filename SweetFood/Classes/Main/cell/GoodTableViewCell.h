//
//  GoodTableViewCell.h
//  SweetFood
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"
@interface GoodTableViewCell : UITableViewCell


@property (nonatomic, strong) GoodModel *goodModel;

//定义一个类方法，在外部调用，通过传入model参数，计算出来每个cell的高度
+(CGFloat )getCellHeightWithGoodModel:(GoodModel *)model;

@end
