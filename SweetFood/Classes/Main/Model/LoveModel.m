//
//  LoveModel.m
//  喜欢的点击界面
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "LoveModel.h"

@implementation LoveModel
-(instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.iconView = dic[@"Cover"];
        self.title = dic[@"Title"];
        self.date = dic[@"Collection"];
        self.intro = dic[@"Stuff"];
        self.loveID = dic[@"RecipeId"];
        self.type = dic[@"HasVideo"];
    }
    return self;
}
@end
