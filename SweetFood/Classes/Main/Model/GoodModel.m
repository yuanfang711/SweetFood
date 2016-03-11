//
//  GoodModel.m
//  SweetFood
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel


- (instancetype)initWithNSDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"Title"];
        self.ImageView = dic[@"Cover"];
        self.introl = dic[@"Intro"];
        self.nema = dic[@"UserName"];
        self.foodID = dic[@"RecipeId"];
        self.type = dic[@"HasVideo"];
    }
    return self;
}

@end
